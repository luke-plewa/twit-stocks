require 'spec_helper'

describe Boost do

  let(:boost) { Boost.new(9) }
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

  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises

  let(:start_day_2) { "2014-05-26" }
  let(:end_day_2) { "2014-06-01" } # during this split, time warner's stock falls

  let(:start_day_3) { "2014-05-26" }
  let(:end_day_3) { "2014-06-02" } # during this split, broadcom's stock rises

  let(:learning_rate) { 0.7 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 20 }

  before do
    stocks = [stock, stock, stock, stock, stock_2, stock_2, stock_3, stock_4, stock_5]
    search_terms = [search_term, search_term_2, search_term_3, search_term_4,
      search_term_5, search_term_6, search_term_7, search_term_9, search_term_11]
    boost.train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
    #boost.train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
  end

  describe '#boost' do
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
      twitter = TwitterEngine.new
      tweets = twitter.get_tweets(search_term_10, "recent")
      features = twitter.get_features(tweets)
      result = boost.hypothesis(features)

      market = Market.new
      # quotes = market.get_endprices(stock_4, start_day_3, end_day_3)
      quotes = market.get_endprices(stock_5, start_day_2, end_day_2)
      delta = quotes[0].to_f - quotes[1].to_f
      puts quotes
      puts delta
      puts result

      twitter.print_features(features)

      expect(result).to be > 0.5
    end
  end

end
