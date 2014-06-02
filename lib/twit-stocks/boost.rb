class Boost
  attr_accessor :predictors, :num_predictors, :weights,
    :learning_rate

  def initalize num_predictors
    self.num_predictors = num_predictors
    self.predictors = Array.new(num_predictors) {
      Predictor.new
    }
    self.weights = Array.new(num_predictors, (1 / num_predictors))
  end

  def setup_neural_net index, stock, search_term, start_day, end_day, hidden_nodes
    predictors[index].set_features(stock, search_term, start_day, end_day)
    predictors[index].set_default_network_values(hidden_nodes)
    predictors[index].build_neural_net
  end

  def train_neural_net index, expected_value, learning_rate, momentum_rate
    predictors[index].train(expected_value, learning_rate, momentum_rate)
  end

  def hypothesis iterations
    f_x = 0
    for t in 0..iterations
      w_i = Math::E ** (weights[t])
      predictor[t].build_neural_net
      h_t = predictor[t].hypothesis
      a_t = 0.5 * Math.log(Math::E)
      f_x += a_t * h_t
    end
  end
end
