require 'spec_helper'

describe Predictor do

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:start_day) { "2011-12-21" }
  let(:end_day) { "2011-12-22" }
  let(:learning_rate) { 0.3 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }

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
    it 'correctly trains once' do
      predictor.train(expected_value, learning_rate, momentum_rate)
      predictor.build_neural_net
      expect(predictor.hypothesis).to be > 0
    end

    it 'correctly trains multiple times' do
      (0...20).each do
        predictor.train(expected_value, learning_rate, momentum_rate)
        predictor.build_neural_net
        puts predictor.hypothesis
      end
      expect(predictor.hypothesis).to be > 0
    end
  end

end
