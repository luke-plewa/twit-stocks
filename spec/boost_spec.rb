require 'spec_helper'

describe Boost do

  let(:boost) { Boost.new(7) }
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

  let(:stock_3) { :GRPN }
  let(:search_term_8) { "groupon" }

  let(:stock_3) { :BRCM }
  let(:search_term_9) { "broadcom" }
  let(:search_term_10) { "baseband" }

  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises

  let(:start_day_2) { "2014-01-26" }
  let(:end_day_2) { "2014-06-01" } # during this split, groupon's stock falls

  let(:start_day_3) { "2014-05-26" }
  let(:end_day_3) { "2014-06-02" } # during this split, broadcom's stock rises

  let(:learning_rate) { 0.7 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 10 }

  before do
    boost.setup_neural_net(0, stock, search_term, start_day, end_day, hidden_nodes)
    boost.train_neural_net(0, boost.get_delta(0), learning_rate, momentum_rate)
    boost.setup_neural_net(1, stock, search_term_2, start_day, end_day, hidden_nodes)
    boost.train_neural_net(1, boost.get_delta(1), learning_rate, momentum_rate)
    boost.setup_neural_net(2, stock, search_term_3, start_day, end_day, hidden_nodes)
    boost.train_neural_net(2, boost.get_delta(2), learning_rate, momentum_rate)
    boost.setup_neural_net(3, stock, search_term_4, start_day, end_day, hidden_nodes)
    boost.train_neural_net(3, boost.get_delta(3), learning_rate, momentum_rate)

    boost.setup_neural_net(4, stock_2, search_term_5, start_day, end_day, hidden_nodes)
    boost.train_neural_net(4, boost.get_delta(4), learning_rate, momentum_rate)
    boost.setup_neural_net(5, stock_2, search_term_6, start_day, end_day, hidden_nodes)
    boost.train_neural_net(5, boost.get_delta(5), learning_rate, momentum_rate)

    boost.setup_neural_net(6, stock_3, search_term_7, start_day, end_day, hidden_nodes)
    boost.train_neural_net(6, boost.get_delta(6), learning_rate, momentum_rate)
  end

  describe '#boost' do
    it 'correctly predicts on many nets' do
      twitter = TwitterEngine.new
      tweets = twitter.get_tweets(search_term, "recent")
      features = twitter.get_features(tweets)
      result = boost.hypothesis(features)
      expect(result).to be > 0.5
    end

    it 'correctly predicts a negative trend' do
      twitter = TwitterEngine.new
      tweets = twitter.get_tweets(search_term_8, "recent")
      features = twitter.get_features(tweets)
      result = boost.hypothesis(features)

      market = Market.new
      quotes = market.get_endprices(stock_3, start_day_2, end_day_2)
      delta = quotes[0].to_f - quotes[1].to_f
      puts quotes
      puts result

      expect(result).to be < 0.5
    end
  end

end
