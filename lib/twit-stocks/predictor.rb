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

    :output_error_gradients, :hidden_error_gradients,
    :previous_input_weight_deltas, :previous_hidden_weight_deltas

  def set_default_network_values
    self.num_input_nodes = features.length
    self.num_hidden_nodes = 10
    self.num_output_nodes = 1

    self.input_weights = Array.new(num_hidden_nodes) {
      Array.new(num_input_nodes+1)
    }
    self.hidden_weights = Array.new(num_output_nodes) {
      Array.new(num_hidden_nodes+1)
    }

    random_weights(input_weights)
    random_weights(hidden_weights)
  end

  def set_default_features features
    self.features = features
  end

  def set_features stock, search_term, start_day, end_day
    self.market = Market.new
    quotes = market.get_endprices(stock, start_day, end_day)
    self.start_price = quotes[0].to_f
    self.end_price = quotes[1].to_f
    self.delta = start_price.to_f - end_price.to_f

    self.twitter = TwitterEngine.new
    self.tweets = twitter.get_tweets(search_term, "recent")
    self.features = twitter.get_features(tweets)
  end

  def set_network_values input_weights, hidden_weights, num_hidden_nodes, num_output_nodes
    self.input_weights = input_weights
    self.hidden_weights = hidden_weights

    self.num_hidden_nodes = num_hidden_nodes
    self.num_output_nodes = num_output_nodes
  end

  def build_neural_net
    self.input_layer = Array.new(features.length, 0)
    features.each_with_index do |count, index|
      input_layer[index] = count
    end

    self.hidden_layer = build_new_hidden_layer(num_hidden_nodes, input_layer, input_weights)
    self.output_layer = build_new_hidden_layer(num_output_nodes, hidden_layer, hidden_weights)
  end

  def random_weights(weights)
    (0...weights.size).each do |i|
      (0...weights[i].size).each do |j|
        weights[i][j] = (rand(100) - 49).to_f / 100
      end
    end
  end

  def build_new_hidden_layer layer_size, input_layer, weights
    next_layer = Array.new(layer_size, 0)

    (0...weights.size).each do |index|
      combined_array = input_layer.zip(weights[index])
      value = combined_array.map{|v,w| v*w}.inject(:+)
      node = sigmoid(value)
      next_layer[index] = node
    end

    next_layer
  end

  def predict stock, search_term, start_day, end_day
    set_features(stock, search_term, start_day, end_day)
    set_default_network_values
    build_neural_net
    hypothesis
  end

  def hypothesis
    output_layer[0]
  end

  def train expected_value, learning_rate
    hypothesis
  end

  def sigmoid x
    1.0 / (1 + Math::E** -x)
  end

  def d_sigmoid(x)
    sigmoid(x) * (1 - sigmoid(x))
  end

  def boost iterations
    f_x = 0
    for t in 0..iterations
      w_i = Math::E ** ()
      h_t = 0 # hypothesis
      a_t = 0.5 * Math.log(Math::E)
      f_x += a_t * h_t
    end
  end

end
