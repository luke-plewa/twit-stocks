class Predictor

  # top level metadata
  attr_accessor :features, :outputs, :market, :twitter, :tweets,

    # stock metadata
    :stock, :start_day, :end_day,

    # stock price values
    :start_price, :end_price, :delta,

    # neural network
    :input_layer, :hidden_layer, :output_layer,
    :num_input_nodes, :num_hidden_nodes, :num_output_nodes,
    :input_weights, :hidden_weights,

    # back propagation NN
    :output_error, :hidden_error,
    :previous_input_weight_deltas, :previous_hidden_weight_deltas

  def set_features stock, search_term, start_day, end_day
    self.market = Market.new
    self.start_day = start_day
    self.end_day = end_day
    self.stock = stock
    quotes = market.get_endprices(stock, start_day, end_day)
    self.start_price = quotes[0].to_f
    self.end_price = quotes[1].to_f
    self.delta = start_price.to_f - end_price.to_f

    self.twitter = TwitterEngine.new
    self.tweets = twitter.get_tweets(search_term, "recent")
    self.features = twitter.get_features(tweets)
  end

  def normalize_expected value
    if value > 0 then 1 else 0 end
  end

  def set_new_features search_term
    self.tweets = twitter.get_tweets(search_term, "recent")
    self.features = twitter.get_features(tweets)
    build_neural_net
  end

  def set_default_network_values hidden_nodes
    self.num_input_nodes = features.length
    self.num_hidden_nodes = hidden_nodes
    self.num_output_nodes = 1

    self.input_weights = Array.new(num_hidden_nodes) {
      Array.new(num_input_nodes+1)
    }
    self.hidden_weights = Array.new(num_output_nodes) {
      Array.new(num_hidden_nodes+1)
    }

    random_weights(input_weights)
    random_weights(hidden_weights)

    self.previous_input_weight_deltas = Array.new(num_hidden_nodes) {
      Array.new(num_input_nodes+1, 0)
    }
    self.previous_hidden_weight_deltas = Array.new(num_output_nodes) {
      Array.new(num_hidden_nodes+1, 0)
    }
  end

  def set_network_values input_weights, hidden_weights, num_hidden_nodes, num_output_nodes
    self.input_weights = input_weights
    self.hidden_weights = hidden_weights

    self.num_hidden_nodes = num_hidden_nodes
    self.num_output_nodes = num_output_nodes
  end

  def build_input_layer
    self.input_layer = Array.new(features.length, 0)
    features.each_with_index do |count, index|
      input_layer[index] = count
    end
    input_layer[-1] = -1
  end

  def build_neural_net
    build_input_layer
    self.hidden_layer = build_new_layer(num_hidden_nodes+1, input_layer, input_weights)
    hidden_layer[-1] = -1
    self.output_layer = build_new_layer(num_output_nodes, hidden_layer, hidden_weights)
  end

  def random_weights(weights)
    (0...weights.size).each do |i|
      (0...weights[i].size).each do |j|
        weights[i][j] = rand(-0.5...0.5)
      end
    end
  end

  # goes through forward propagation algorithm
  def build_new_layer layer_size, input_layer, weights
    next_layer = Array.new(layer_size, 0)

    (0...weights.size).each do |index|
      combined_array = input_layer.zip(weights[index])
      z_value = combined_array.map{|v,w| v*w}.inject(:+)
      activation = sigmoid(z_value)
      next_layer[index] = activation
    end

    next_layer
  end

  def hypothesis
    output_layer[0]
  end

  def element_add array_1, array_2
    combined_array = input_layer.zip(weights[index])
    z_value = combined_array.map{|v,w| v*w}.inject(:+)
  end

  def back_propogation expected_value, learning_rate, momentum_rate
    self.output_error = [(expected_value - hypothesis) * d_sigmoid(hypothesis)]
    self.hidden_error = calculate_hidden_error_gradients
    update_weights(hidden_layer, input_layer, input_weights, hidden_error, learning_rate, previous_input_weight_deltas, momentum_rate)
    update_weights(output_layer, hidden_layer, hidden_weights, output_error, learning_rate, previous_hidden_weight_deltas, momentum_rate)
  end

  def reversed_hidden_weights
    reversed = Array.new(hidden_layer.size) {
      Array.new(output_layer.size)
    }
    hidden_weights.each_index do |i|
      hidden_weights[i].each_index do |j|
        reversed[j][i] = hidden_weights[i][j]
      end
    end
    reversed
  end

  def calculate_hidden_error_gradients
    reversed = reversed_hidden_weights
    hidden_layer.each_with_index.map do |node, i|
      combined_array = output_error.zip(reversed[i])
      sum_array = combined_array.map{|error, weight| error*weight}.inject(:+)
      d_sigmoid(hidden_layer[i]) * sum_array
    end
  end

  def update_weights nodes, values, weights, gradients, learning_rate, previous_deltas, momentum_rate
    weights.each_index do |i|
      weights[i].each_index do |j|
        if !values[j].nil? # last weight mismatch because of bias unit
          delta = learning_rate * gradients[i] * values[j]
          weights[i][j] += delta + momentum_rate * previous_deltas[i][j]
          previous_deltas[i][j] = delta
        end
      end
    end
  end

  def train expected_value, learning_rate, momentum_rate
    build_neural_net
    back_propogation(expected_value, learning_rate, momentum_rate)
  end

  # sigmoid function for forward propagation
  def sigmoid x
    1.0 / (1 + Math::E** -x)
  end

  # sigmoid function for back propagation
  def d_sigmoid(x)
    sigmoid(x) * (1 - sigmoid(x))
  end

end
