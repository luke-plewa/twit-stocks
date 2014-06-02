require 'spec_helper'

describe Driver do

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

  let(:stock_4) { :BRCM }
  let(:search_term_9) { "broadcom" }
  let(:search_term_10) { "baseband" }

  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises

  let(:start_day_2) { "2014-05-26" }
  let(:end_day_2) { "2014-06-01" } # during this split, groupon's stock falls

  let(:start_day_3) { "2014-05-26" }
  let(:end_day_3) { "2014-06-02" } # during this split, broadcom's stock rises

  let(:learning_rate) { 0.7 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 10 }

  before do
    stocks = [stock, stock, stock, stock, stock_2, stock_2, stock_3]
    search_terms = [search_term, search_term_2, search_term_3, search_term_4,
      search_term_5, search_term_6, search_term_7]
    boost.train_twice_and_weight(stocks, search_terms, start_day, end_day, hidden_nodes, learning_rate, momentum_rate)
  end

  describe '#drive' do
    it 'run to test things' do
    end
  end
end
