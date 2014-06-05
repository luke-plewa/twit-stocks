require "market_beat"

class Market

  def get_quotes stock, start_day, end_day
    MarketBeat.quotes(stock, start_day, end_day)
  end

  def get_endprices stock, start_day, end_day
    array = MarketBeat.quotes(stock, start_day, end_day)
    # days return in descending order
    [array[1][:open], array[0][:close]]
  end

  def get_prices stock, start_day, end_day
    array = MarketBeat.quotes(stock, start_day, end_day)
    # days return in descending order
    [array[1][:close], array[0][:close]]
  end

  def opening_price my_stock
    MarketBeat.opening_price(my_stock)
  end

  def last_trade_real_time my_stock
    MarketBeat.last_trade_real_time(my_stock)
  end

end
