require 'spec_helper'

describe Predictor do

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }

  before do
  end

  describe '#predict' do
    it 'correctly predicts stock market change' do
      trend = predictor.predict(stock, start_day, end_day)
      expect(trend).to be 1
    end
  end

end
