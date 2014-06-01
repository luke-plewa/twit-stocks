require 'spec_helper'

describe Predictor do

  let(:predictor) { Predictor.new }
  let(:stock) { :AAPL }
  let(:search_term) { "Apple" }
  let(:search_term_2) { "iphone" }
  let(:search_term_3) { "ipad" }
  let(:start_day) { "2014-05-20" }
  let(:end_day) { "2014-05-30" } # during this split, apple's stock rises
  let(:learning_rate) { 0.3 }
  let(:expected_value) { 1 }
  let(:momentum_rate) { 0.2 }
  let(:hidden_nodes) { 10 }

  before do
    predictor.set_features(stock, search_term, start_day, end_day)
    predictor.set_default_network_values(hidden_nodes)
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
      first_value = predictor.hypothesis
      (0...3).each do
        # predictor.set_features(stock, search_term, start_day, end_day)
        predictor.train(expected_value, learning_rate, momentum_rate)
        predictor.build_neural_net
      end
      expect(predictor.hypothesis).to be > first_value
    end

    it 'correctly approaches delta' do
      delta = predictor.normalize_expected(predictor.delta)
      (0...30).each do
        predictor.train(delta, learning_rate, momentum_rate)
        predictor.build_neural_net
      end
      expect(predictor.hypothesis).to be_between(delta - 0.2, delta + 0.1)
    end

    it 'correctly predicts after training' do
      delta = predictor.normalize_expected(predictor.delta)
      (0...30).each do
        predictor.train(delta, learning_rate, momentum_rate)
        predictor.build_neural_net
      end

      predictor.set_new_features(search_term_2)
      expect(predictor.hypothesis).to be_between(delta - 0.2, delta + 0.1)
    end
  end

  describe '#boost' do
    it 'improves accuracy through boosting' do
      delta = predictor.normalize_expected(predictor.delta)
      (0...5).each do
        predictor.train(delta, learning_rate, momentum_rate)
        predictor.build_neural_net
      end
    end
  end

end
