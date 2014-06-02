#!/usr/bin/env ruby

require_relative 'twitter_engine.rb'
require_relative 'predictor.rb'
require_relative 'market.rb'
require_relative 'boost.rb'

MIXED_TYPE = "mixed"
stock = :APPL
search_term = "iphone"
start_day = "2014-05-20"
end_day = "2014-05-30"
learning_rate = 0.3
momentum_rate = 0.2
hidden_nodes = 10

puts "Booting Twitter Stocks driver..."

predictor = Predictor.new

predictor.set_features(stock, search_term, start_day, end_day)
predictor.set_default_network_values(hidden_nodes)
predictor.build_neural_net

puts predictor.delta
delta = predictor.normalize_expected(predictor.delta)
(0...30).each do
  predictor.train(delta, learning_rate, momentum_rate)
  predictor.build_neural_net
end
puts predictor.hypothesis
