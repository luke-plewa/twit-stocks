#!/usr/bin/env ruby
require_relative 'lib/twit-stocks/twitter_engine.rb'
require_relative 'lib/twit-stocks/predictor.rb'
require_relative 'lib/twit-stocks/market.rb'
require_relative 'lib/twit-stocks/boost.rb'

puts "Starting to predict stocks..."

start_day = "2014-05-30"
end_day = "2014-06-04"  # during this split, apple's stock ris

start_day_2 = "2014-05-26"
end_day_2 = "2014-06-01"  # during this split, time warner's stock fal

start_day_3 = "2014-05-26"
end_day_3 = "2014-06-02"  # during this split, broadcom's stock ris

start_day_4 = "2014-05-30"
end_day_4 = "2014-06-02"  # during this split, gamestop's stock fal

start_day_5 = "2014-06-03"
end_day_5 = "2014-06-04"  # this split represents the past we

learning_rate = 0.5
expected_value = 1
momentum_rate = 0.3
hidden_nodes = 20

stocks = [:AAPL, :AAPL, :AAPL, :AAPL, :GOOG, :ADBE, :BRCM, :BRCM, :TWX,
  :HAS, :GME, :WYNN, :UA, :NFLX, :T, :CMCSK, :CMCSA, :CVX,
  :CSCO, :BA]
search_terms = ["apple", "iphone", "ipad", "macbook",
  "googleglass", "adobe", "broadcom", "baseband", "time warner",
  "hasbro", "gamestop", "wynn",
  "under armor", "netflix", "at&t", "comcast", "comcast", "chevron",
  "cisco", "boeing"
]

#stocks = [:AAPL, :GOOG, :ADBE, :BRCM, :TWX,
#  :HAS, :GME, :WYNN, :UA, :NFLX, :T, :CMCSK, :CMCSA, :CVX,
#  :CSCO, :BA]
#search_terms = ["apple",
#  "google", "adobe", "broadcom", "time warner",
#  "hasbro", "gamestop", "wynn",
#  "under armor", "netflix", "at&t", "comcast", "comcast", "chevron",
#  "cisco", "boeing"
#]

boost = Boost.new(stocks.length)
twitter = TwitterEngine.new

puts "begin training neural networks..."
if !ARGV[2].nil? && ARGV[2].eql?("read") then
  features = Array.new
  stocks.each_with_index do |stock, index|
    features << twitter.read_features(stock)
  end
  puts "reading from recorded tweets..."
  boost.train_with_features(stocks, features, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
else
  puts "pulling tweets from twitter..."
  boost.train_twice_and_weight(stocks, search_terms, start_day_5, end_day_5, hidden_nodes, learning_rate, momentum_rate)
  stocks.each_with_index do |stock, index|
    twitter.record_features(boost.predictors[index].features, stock)
  end
end

term = ARGV[0]
my_stock = ARGV[1]

twitter = TwitterEngine.new
tweets = twitter.get_tweets(term, "recent")
new_features = twitter.get_features(tweets)
twitter.print_features(new_features)
result = boost.hypothesis(new_features)

market = Market.new
quotes = market.get_prices(my_stock, "2014-06-03", "2014-06-04")
# quotes = market.get_endprices(my_stock, "2014-06-04", "2014-06-04")
# quotes << market.opening_price(my_stock)
# quotes << market.last_trade_real_time(my_stock)
delta = quotes[1].to_f - quotes[0].to_f

puts "predicting on #{ARGV[0]} with stock label #{ARGV[1]}"
puts quotes
puts "delta: " + delta.to_s
puts "classification: " + result.to_s
puts "discrete value: " + (result - 0.5).to_s
