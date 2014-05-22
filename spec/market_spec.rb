require 'spec_helper'

describe Market do

  let(:market) { Market.new }
  let(:stock) { :AAPL }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }

  before do
  end

  describe '#quotes' do
    it 'marketbeat returns two days of quotes' do
      array = MarketBeat.quotes(stock, start_day, end_day)
      expect(array.size).to be 2
    end


    it 'market returns two days of quotes' do
      array = market.get_quotes(stock, start_day, end_day)
      expect(array.size).to be 2
    end
  end

  describe "#get_endprices" do
    it 'returns start and end prices' do
      array = market.get_endprices(stock, start_day, end_day)
      expect(array.size).to be 2
    end

    it 'returns the correct first quote' do
      array = market.get_endprices(stock, start_day, end_day)
      expect(array[0]).to eq("397.00")
    end

    it 'returns the correct last quote' do
      array = market.get_endprices(stock, start_day, end_day)
      expect(array[1]).to eq("396.44")
    end
  end

end
