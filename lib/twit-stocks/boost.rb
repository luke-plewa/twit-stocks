class Boost
  attr_accessor :predictors, :num_predictors, :weights,
    :learning_rate, :errors, :samples

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

  def normalize_expected expected_value
    if expected_value > 0 then 1 else 0 end
  end

  def train_neural_net index, expected_value, learning_rate, momentum_rate
    predictors[index].train(normalize_expected(expected_value), learning_rate, momentum_rate)
  end

  def next_best_error old_error_index
    max_error = 0
    error_index = 0
    next_best_error_index = 0
    errors.each_with_index do |error, index|
      if max_error < error.error then
        next_best_error_index = error_index
        error_index = index
        max_error = error.error
      end
    end
    if old_error_index == error_index then
      return errors[next_best_error_index].error - 0.001
    else
      return errors[old_error_index].error
    end
  end

  def adjust_weight index, expected_value, error_index
    error = error_func(predictors[index].hypothesis, normalize_expected(expected_value))
    weights[index] = weights[index] * (1.0 - error)
    if errors[error_index].error == 0 then
      errors[error_index].error = error
    else
      errors[error_index].error = error
      errors[error_index].error = next_best_error(error_index)
    end
    puts "hypothesis: " + predictors[error_index].hypothesis.to_s
    puts "error: " + error.to_s
    puts "expected_value: " + expected_value.to_s
  end

  def error_func hypothesis, expected_value
    (expected_value - hypothesis).abs
  end

  def train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
    self.errors = Array.new(search_terms.length, ErrorNode.new)
    predictors.each_with_index do |predictor, index|
      setup_neural_net(index, stocks[index], search_terms[index], start_day, end_day, hidden_nodes)
      train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
      train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
      adjust_weight(index, get_delta(index), index)
    end
  end

  def train_with_features stocks, features, start_day, end_day, hidden_nodes, learning_rate, momentum_rate
    self.samples = features
    create_errors(stocks, features)

    predictors.each_with_index do |predictor, index|
      predictors[index].set_stocks(stocks[index], features[index], start_day, end_day)
      predictors[index].set_default_network_values(hidden_nodes)
      predictors[index].build_neural_net
      train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
      puts "stock: " + stocks[index].to_s
      adjust_weight(index, get_delta(index), index)
    end

    errors.each_with_index do |error, index|
      puts index.to_s + " " + error.stock.to_s + " " + error.error.to_s
    end

    predictors.each_with_index do |predictor, index|
      train_on_highest_error(predictors[index], index, start_day, end_day, learning_rate, momentum_rate)
      train_on_highest_error(predictors[index], index, start_day, end_day, learning_rate, momentum_rate)
    end
  end

  def train_on_highest_error predictor, index, start_day, end_day, learning_rate, momentum_rate
    max_error = 0
    error_index = 0
    errors.each_with_index do |error, index|
      if max_error < error.error then
        error_index = index
        max_error = error.error
      end
    end
    err_node = errors[error_index]

    predictor.set_stocks(err_node.stock, err_node.features, start_day, end_day)
    predictor.build_neural_net
    train_neural_net(index, get_delta(index), learning_rate, momentum_rate)
    puts "stock: " + err_node.stock.to_s
    adjust_weight(index, get_delta(index), error_index)
  end

  def create_errors stocks, features
    self.errors = Array.new(features.length) { ErrorNode.new }
    errors.each_with_index do |error, index|
      error.stock = stocks[index]
      error.error = 0
      error.features = features[index]
    end
  end

  def hypothesis features
    f_x = 0
    for t in 0...num_predictors
      predictors[t].reset_features(features)
      h_t = predictors[t].hypothesis
      f_x += h_t * (weights[t] / sum_weights)
      puts "hypo: " + h_t.to_s
      puts "weight: " + weights[t].to_s
    end
    f_x
  end
end

class ErrorNode
  attr_accessor :error, :features, :stock
end
