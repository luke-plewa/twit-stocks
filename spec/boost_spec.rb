require 'spec_helper'

describe Boost do

  let(:boost) { Boost.new(14) }
  let(:twitter) { TwitterEngine.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:search_term_2) { "iphone" }
  let(:search_term_3) { "ipad" }
  let(:search_term_4) { "macbook" }

  let(:stock_2) { :GOOG }
  let(:search_term_5) { "Google" }
  let(:search_term_6) { "googleglass" }

  let(:stock_3) { :ADBE }
  let(:search_term_7) { "Adobe" }
  let(:search_term_8) { "groupon" }

  let(:stock_4) { :BRCM }
  let(:search_term_9) { "broadcom" }
  let(:search_term_10) { "baseband" }

  let(:stock_5) { :TWX }
  let(:search_term_11) { "time warner" }

  let(:stock_6) { :HAS }
  let(:search_term_12) { "hasbro" }

  let(:stock_7) { :GME }
  let(:search_term_13) { "gamestop" }

  let(:stock_8) { :WYNN }
  let(:search_term_14) { "wynn" }

  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises

  let(:start_day_2) { "2014-05-26" }
  let(:end_day_2) { "2014-06-01" } # during this split, time warner's stock falls

  let(:start_day_3) { "2014-05-26" }
  let(:end_day_3) { "2014-06-02" } # during this split, broadcom's stock rises

  let(:start_day_4) { "2014-05-30" }
  let(:end_day_4) { "2014-06-02" } # during this split, gamestop's stock falls

  let(:start_day_5) { "2014-05-27" }
  let(:end_day_5) { "2014-06-03" } # this split represents the past week

  let(:learning_rate) { 0.7 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 20 }

  before do
    stocks = [stock, stock, stock, stock, stock_2, stock_2, stock_3, stock_4, stock_5,
      stock_6, stock_7, stock_5, stock_7, stock_8]
    search_terms = [search_term, search_term_2, search_term_3, search_term_4,
      search_term_5, search_term_6, search_term_7, search_term_9, search_term_11,
      search_term_12, search_term_13, search_term_11, search_term_13, search_term_14]

    features = []
    stocks.each_with_index do |stock, index|
      features << twitter.read_features(stock)
    end

    puts features.length

    # boost.train_twice_and_weight(stocks, search_terms, start_day_5, end_day_5, hidden_nodes, learning_rate, momentum_rate)
    boost.train_with_features(stocks, features, start_day_5, end_day_5, hidden_nodes, learning_rate, momentum_rate)

    # stocks.each_with_index do |stock, index|
    #   twitter.record_features(boost.predictors[index].features, stock)
    # end
  end

  describe '#boost' do

    #it 'classifies with a classifier' do
    #stocks = [stock, stock, stock, stock, stock_2, stock_2, stock_3, stock_4, stock_5,
    #  stock_6, stock_7, stock_5, stock_7]
    #search_terms = [search_term, search_term_2, search_term_3, search_term_4,
    #  search_term_5, search_term_6, search_term_7, search_term_9, search_term_11,
    #  search_term_12, search_term_13, search_term_11, search_term_13]
    #  predictor = Predictor.new
    #  predictor.set_features(stock, search_term, start_day, end_day)
    #  predictor.set_default_network_values(hidden_nodes)
    #  predictor.build_neural_net
#
    #  stocks.each_with_index do |stock, index|
    #    predictor.set_features(stock, search_terms[index], start_day_5, end_day_5)
    #    predictor.train(expected_value, learning_rate, momentum_rate)
    #    predictor.build_neural_net
    #  end
#
    #  predictor.set_features(stock_3, search_term_7, start_day_5, end_day_5)
    #  predictor.build_neural_net
    #  puts predictor.delta
    #  puts predictor.hypothesis
    #end

    #it 'classifies with a different num of classifiers' do
    #stocks = [stock, stock, stock, stock, stock_2, stock_2, stock_3, stock_4, stock_5,
    #  stock_6, stock_7, stock_5, stock_7]
    #search_terms = [search_term, search_term_2, search_term_3, search_term_4,
    #  search_term_5, search_term_6, search_term_7, search_term_9, search_term_11,
    #  search_term_12, search_term_13, search_term_11, search_term_13]
#
    # boost.train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
#
    #  twitter = TwitterEngine.new
    #  tweets = twitter.get_tweets("googleglass", "recent")
    #  features = twitter.get_features(tweets)
    #  result = boost.hypothesis(features)
#
    #  market = Market.new
    #  quotes = market.get_endprices(:ADBE, start_day_4, end_day_4)
    #  delta = quotes[0].to_f - quotes[1].to_f
    #  puts delta
    #  puts result
    #end

    #it 'correctly predicts on many nets' do
      #twitter = TwitterEngine.new
      #tweets = twitter.get_tweets(search_term, "recent")
      #features = twitter.get_features(tweets)
      #result = boost.hypothesis(features)
      #expect(result).to be > 0.5
    #end

    #it 'correctly predicts a negative trend' do
      #twitter = TwitterEngine.new
      #tweets = twitter.get_tweets(search_term_8, "recent")
      #features = twitter.get_features(tweets)
      #result = boost.hypothesis(features)
      #market = Market.new
      #quotes = market.get_endprices(stock_3, start_day_2, end_day_2)
      #delta = quotes[0].to_f - quotes[1].to_f
      #expect(result).to be < 0.5
    #end

    it 'correctly predicts broadcom rise' do
      term = "facebook"
      my_stock = :FB

      twitter = TwitterEngine.new
      tweets = twitter.get_tweets(term, "recent")
      features = twitter.get_features(tweets)
      result = boost.hypothesis(features)

      market = Market.new
      quotes = market.get_endprices(my_stock, "2014-06-03", "2014-06-04")
      delta = quotes[0].to_f - quotes[1].to_f

      puts my_stock
      puts quotes
      puts delta
      puts result
      #twitter.print_features(features)

      expect(result).to be > 0
    end
  end

end
