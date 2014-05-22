require "twitter"

class TwitterEngine

  attr_accessor :client, :features

  FEATURES = [
    ["worst", "terrible", "horrible"],
    ["garbage", "miserable", "embarrassing", "painful"],
    ["suck", "crap", "poop", "awful", "rotten"],
    ["bad", "poor", "not good"],
    ["boring", "unfunny", "overrated"],
    ["okay", "decent", "not bad"],
    ["good", "alright", "enjoy"],
    ["great", "better", "well done", "excite"],
    ["love", "marvelous", "fabulous", "legit", "fresh"],
    ["awesome", "excellent", "amazing", "must see"],
    ["best", "incredible", "Oscar"]
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
    self.features = Hash.new
    self.features.default = 0
    tweets[:statuses].each_with_index { |tweet, index|
      parse_tweet tweet[:text]
    }
    features
  end

  def parse_tweet text
    FEATURES.each do |set|
      set.each do |feature|
        if text.include? feature
          features[feature] += 1
        end
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
    File.open("tweets", 'wb') { |file|
      file.write(tweets_text)
    }
  end

  def read_tweets
    File.open("tweets", "r").each_line do |line|
    end
  end

end
