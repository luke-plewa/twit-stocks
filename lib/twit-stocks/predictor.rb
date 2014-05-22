class Predictor

  # top level metadata
  attr_accessor :features, :outputs, :market, :twitter,

    # stock metadata
    :stock, :start_day, :end_day,

    # stock price values
    :start_price, :end_price, :delta,

    # tweets
    :tweets

  def setup stock, start_day, end_day
    self.market = Market.new
    quotes = market.get_endprices(stock, start_day, end_day)
    self.start_price = quotes[0]
    self.end_price = quotes[1]
    self.delta = start_price - end_price

    self.twitter = TwitterEngine.new
    twitter.setup
    self.tweets = twitter.get_tweets(stock, "recent")
    self.features = twitter.get_features(tweets)
  end

  def predict stock, start_day, end_day
    setup(stock, start_day, end_day)
    return 1
  end

  def hypothesis inputs

  end

  def sigmoid z
    1.0 / (1.0 + exp(-z));
  end

end
