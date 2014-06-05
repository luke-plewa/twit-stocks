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
    "best", "incredible", "hot", "new",
    "miss", "overdue", "impressive", "kill", "grow",
    "evil", "piss"
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

  def print_features features
    features.each_with_index do |feature, index|
      if !FEATURES[index].nil? && feature > 0
        puts feature.to_s + " " + FEATURES[index]
      end
    end
  end

  def get_tweets search_string, type
    # "mixed", "recent", and "popular". The current default is "mixed."
    results = client.search(search_string, result_type: type)
  end

  def get_features tweets
    self.features = Array.new(FEATURES.length, 0)
    count = 0
    tweets.each do |tweet|
      parse_tweet tweet.text
      count += 1
    end
    features << count
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
    tweets = client.search(search_string, result_type: "recent")
    tweets[:statuses].each do |tweet|
      # puts tweet.text
    end
    tweets
  end

  def record_features features, stock
    old_features = read_features(stock)
    File.open("samples/#{stock}_features.txt", 'w') do |file|
      features.each_with_index do |features_text, index|
        if !old_features[index].nil?
          file.write((features_text + old_features[index].to_i).to_s + "\n")
        else
          file.write(features_text.to_s + "\n")
        end
      end
    end
  end

  def read_features stock
    features = []
    if File.exist?("samples/#{stock}_features.txt")
      File.open("samples/#{stock}_features.txt", "r").each_line do |line|
        features << line.to_i
      end
    end
    features
  end

end
