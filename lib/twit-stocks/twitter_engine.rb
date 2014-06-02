require "twitter"

class TwitterEngine

  attr_accessor :client, :features

  FEATURES = [
    "worst", "terrible", "horrible", "hate",
    "garbage", "miserable", "embarrassing", "painful",
    "suck", "crap", "poop", "awful", "rotten", "slow",
    "bad", "poor", "not good", "broke", "dumb",
    "boring", "unfunny", "overrated", "obnoxious",
    "okay", "decent", "not bad", "won't", "want",
    "good", "alright", "enjoy", "sell", "buy", "must",
    "great", "better", "well done", "excite", "happy",
    "love", "marvelous", "fabulous", "legit", "fresh",
    "awesome", "excellent", "amazing", "must see",
    "best", "incredible", "hot", "new"
  ]

  def initialize
    setup
  end

  def setup
    self.client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "QpxDmEy2sfNN4MNzKXihk0GwQ"
      config.consumer_secret     = "vlMiEiwYA3y1iw00jwoAHoo7q33v7UX1vaPn73Dq6zLPX02oGI"
      config.access_token        = "354589333-0EFXMVUvR5MrukVUtGHVCSunHrrzSmYVy1BE2Afq"
      config.access_token_secret = "q4KBVMmiRQkgR2jE9cZHeQjZeXtU7FDABimiexQoEr2mo"
    end
  end

  def get_tweets search_string, type
    # "mixed", "recent", and "popular". The current default is "mixed."
    client.search(search_string, result_type: type).to_h
  end

  def get_features tweets
    self.features = Array.new(FEATURES.length, 0)
    tweets[:statuses].each_with_index do |tweet, index|
      parse_tweet tweet[:text]
    end
    features << tweets[:statuses].length
    features
  end

  def parse_tweet text
    FEATURES.each_with_index do |feature, index|
      if text.include? feature
        features[index] += 1
      end
    end
  end

  def print_search search_string
    tweets = client.search(search_string, result_type: "recent").take(3)
    tweets.each do |tweet|
      # puts tweet.text
    end
    tweets
  end

  def record_tweets tweets
    tweets_text = ""
    File.open("tweets", 'wb') do |file|
      file.write(tweets_text)
    end
  end

  def read_tweets
    File.open("tweets", "r").each_line do |line|
    end
  end

end
