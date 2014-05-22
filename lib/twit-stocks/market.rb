require "market_beat"

class Market

  def get_quotes stock, start_day, end_day
    MarketBeat.quotes(stock, start_day, end_day)
  end

  def get_endprices stock, start_day, end_day
    array = MarketBeat.quotes(stock, start_day, end_day)
    [array[0][:open], array[1][:close]]
  end

end
