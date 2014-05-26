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

  def predict stock, search_term, start_day, end_day
    setup(stock, search_term, start_day, end_day)
    return 1
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
