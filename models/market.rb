require "market_beat"

class Market

  attr_accessor :thing

  def setup
  end

  def get_quotes stock, start_day, end_day
    MarketBeat.quotes(stock, start_day, end_day)
  end

end
