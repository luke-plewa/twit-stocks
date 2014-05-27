class Predictor

  # top level metadata
  attr_accessor :features, :outputs, :market, :twitter,

    # stock metadata
    :stock, :start_day, :end_day,

    # stock price values
    :start_price, :end_price, :delta,

    # tweets
    :tweets,

    # neural network
    :input_layer, :hidden_layer, :output_layer

  FEATURES = [
    ["worst", "terrible", "horrible"],
    ["garbage", "miserable", "embarrassing", "painful"],
    ["suck", "crap", "poop", "awful", "rotten"],
    ["bad", "poor", "not good", "broken"],
    ["boring", "unfunny", "overrated"],
    ["okay", "decent", "not bad"],
    ["good", "alright", "enjoy"],
    ["great", "better", "well done", "excite"],
    ["love", "marvelous", "fabulous", "legit", "fresh"],
    ["awesome", "excellent", "amazing"],
    ["best", "incredible"] # top
  ]

  def setup stock, search_term, start_day, end_day
    self.market = Market.new
    quotes = market.get_endprices(stock, start_day, end_day)
    self.start_price = quotes[0].to_f
    self.end_price = quotes[1].to_f
    self.delta = start_price.to_f - end_price.to_f

    self.twitter = TwitterEngine.new
    self.tweets = twitter.get_tweets(search_term, "recent")
    self.features = twitter.get_features(tweets)
  end

  def build_neural_net
    build_input_layer
    self.hidden_layer = build_new_layer(input_layer, input_layer.size)
    self.output_layer = build_new_layer(hidden_layer, 1)
  end

  def build_new_layer layer, size
    next_layer = Array.new()
    weights = Array.new(layer.size, 1)
    inputs = Array.new(layer.size, 0)

    layer.each_with_index do |node, index|
      inputs[index] = node.value
    end

    for index in 0..size
      next_layer << Node.new(inputs, weights)
    end
    next_layer
  end

  def build_output_layer
    self.output_layer = Array.new
  end

  def build_input_layer
    self.input_layer = Array.new
    weights = Array.new(features.size, 1)
    inputs = Array.new(features.size, 0)

    features.each_with_index do |(feature, count), index|
      inputs[index] = count
    end

    inputs.each_with_index do |input, index|
      input_layer << Node.new([input], [weights[index]])
    end
  end

  def predict stock, search_term, start_day, end_day
    setup(stock, search_term, start_day, end_day)
    build_neural_net
    output_layer.first.value
  end

  def hypothesis

  end

  def sigmoid z
    1.0 / (1.0 + exp(-z));
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
