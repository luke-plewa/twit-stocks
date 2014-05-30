require 'spec_helper'

describe Predictor do

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }

  before do
    predictor.set_features(stock, search_term, start_day, end_day)
    predictor.set_default_network_values
    predictor.build_neural_net
  end

  describe '#set_features' do
    it 'correctly generates features' do
      expect(predictor.features.size).to be > 1
    end
  end

  describe '#hypothesis' do
    it 'builds an input layer' do
      expect(predictor.input_layer.size).to be predictor.features.size
    end

    it 'builds a hidden layer' do
      expect(predictor.hidden_layer.size).to be > 0
    end

    it 'builds an output layer' do
      expect(predictor.output_layer.size).to be 1
    end

    it 'correctly predicts' do
      expect(predictor.hypothesis).to be > 0
    end
  end

  describe '#train' do
    it 'correctly trains' do
      learning_rate = 0.3
      expected_value = 1
      value = predictor.train(expected_value, learning_rate)
      expect(value).to be > 0
    end
  end

end
