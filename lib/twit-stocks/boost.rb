class Boost
  attr_accessor :predictor

  def initalize
    self.predictor = Predictor.new
  end

  def setup_neural_net stock, search_term, start_day, end_day, hidden_nodes
    predictor.set_features(stock, search_term, start_day, end_day)
    predictor.set_default_network_values(hidden_nodes)
    predictor.build_neural_net
  end

  def train_neural_net expected_value, learning_rate, momentum_rate
    predictor.train(expected_value, learning_rate, momentum_rate)
  end

  def boost iterations, search_terms
    f_x = 0
    for t in 0..iterations
      w_i = Math::E ** ()
      build_neural_net
      h_t = hypothesis
      a_t = 0.5 * Math.log(Math::E)
      f_x += a_t * h_t
    end
  end
end
