require 'spec_helper'

describe Predictor do

  FEATURES = [
    ["worst", "terrible", "horrible"],
    ["garbage", "miserable", "embarrassing", "painful"],
    ["suck", "crap", "poop", "awful", "rotten"],
    ["bad", "poor", "not good", "broken"],
    ["boring", "unfunny", "overrated"],
    ["okay", "decent", "not bad"],
    ["good", "alright", "enjoy"],
    ["great", "better", "well done", "excite"],
    ["love", "marvelous", "fabulous", "legit", "fresh"],
    ["awesome", "excellent", "amazing"],
    ["best", "incredible"] # top
  ]

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }
  let(:sample_features) { Hash.new(0) }

  before do
    sample_features["worst"] = 10
    sample_features["garbage"] = 5
    sample_features["awful"] = 15
    sample_features["worst"] = 10
    sample_features["rotten"] = 15
    sample_features["boring"] = 10
    sample_features["good"] = 15
    sample_features["alright"] = 10
    sample_features["enjoy"] = 15
    sample_features["fabulous"] = 10
    sample_features["legit"] = 15
    sample_features["awesome"] = 10
    sample_features["incredible"] = 10
    sample_features["best"] = 20
  end

  describe '#predict' do
    it 'correctly predicts stock market change' do
      trend = predictor.predict(stock, search_term, start_day, end_day)
      expect(trend).to be 1
    end

    it 'correctly generates features' do
      predictor.predict(stock, search_term,  start_day, end_day)
      expect(predictor.features.size).to be > 1
    end
  end

end
