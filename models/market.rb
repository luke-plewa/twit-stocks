require "market_beat"

class Market

  attr_accessor :thing

  def setup
    thing = MarketBeat.quotes(:AAPL, "2011-12-21", "2011-12-22")
    puts thing
  end

end
