class Boost
  attr_accessor :predictors, :num_predictors, :weights,
    :learning_rate

  def initialize num_predictors
    self.num_predictors = num_predictors
    self.predictors = Array.new(num_predictors) {
      Predictor.new
    }
    self.weights = Array.new(num_predictors, 1.0)
  end

  def setup_neural_net index, stock, search_term, start_day, end_day, hidden_nodes
    predictors[index].set_features(stock, search_term, start_day, end_day)
    predictors[index].set_default_network_values(hidden_nodes)
    predictors[index].build_neural_net
  end

  def get_delta index
    predictors[index].delta
  end

  def sum_weights
    sum = 0
    weights.each do |weight|
      sum += weight
    end
    sum
  end

  def train_neural_net index, expected_value, learning_rate, momentum_rate
    predictors[index].train(expected_value, learning_rate, momentum_rate)
  end

  def adjust_weight index, expected_value
    error = error_func(predictors[index].hypothesis, expected_value, index)
    weights[index] = weights[index] * (1.0 - error)
  end

  def error_func hypothesis, expected_value, index
    Math::E ** (-1 * expected_value * predictors[index].hypothesis)
  end

  def train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
    predictors.each_with_index do |predictor, index|
      setup_neural_net(index, stocks[index], search_terms[index], start_day, end_day, hidden_nodes)
      train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
      train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
      adjust_weight(index, get_delta(index))
    end
  end

  def hypothesis features
    f_x = 0
    for t in 0...num_predictors
      # w_i = Math::E ** (weights[t])
      predictors[t].reset_features(features)
      h_t = predictors[t].hypothesis
      # a_t = 0.5 * Math.log(Math::E) # actually want to grab the weighted error sum
      f_x += h_t * (weights[t] / sum_weights)
    end
    f_x
  end
end
