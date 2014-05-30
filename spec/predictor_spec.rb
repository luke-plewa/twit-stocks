require 'spec_helper'

describe Predictor do

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }
  let(:sample_features) { [0, 10, 4, 5, 11, 3, 33, 0, 4, 5, 7, 8] }

  describe '#set_features' do
    it 'correctly generates features' do
      predictor.set_features(stock, search_term,  start_day, end_day)
      expect(predictor.features.size).to be > 1
    end
  end

  describe '#hypothesis' do
    it 'builds an input layer' do
      predictor.set_default_features(sample_features)
      predictor.set_default_network_values
      predictor.hypothesis
      expect(predictor.input_layer.size).to be sample_features.size
    end

    it 'builds a hidden layer' do
      predictor.set_default_features(sample_features)
      predictor.set_default_network_values
      predictor.hypothesis
      expect(predictor.hidden_layer.size).to be > 0
    end

    it 'builds an output layer' do
      predictor.set_default_features(sample_features)
      predictor.set_default_network_values
      predictor.hypothesis
      expect(predictor.output_layer.size).to be 1
    end
  end

  describe '#predict' do
    it 'correctly predicts' do
      value = predictor.predict(stock, search_term,  start_day, end_day)
      expect(value).to be > 0
    end
  end

end
