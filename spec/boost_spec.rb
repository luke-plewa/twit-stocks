require 'spec_helper'

describe Boost do

  let(:boost) { Boost.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:search_term_2) { "iphone" }
  let(:search_term_3) { "ipad" }
  let(:search_term_3) { "macbook" }

  let(:stock_2) { :GOOG }
  let(:search_term_4) { "Google" }
  let(:search_term_5) { "googleglass" }

  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises

  let(:learning_rate) { 0.3 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 10 }

  before do
    boost.setup_neural_net(0, stock, search_term, start_day, end_day, hidden_nodes)
  end

  describe '#boost' do
    it 'correctly generates features' do
    end
  end

end
