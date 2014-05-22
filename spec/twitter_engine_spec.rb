require 'spec_helper'

describe TwitterEngine do

  let(:engine) { TwitterEngine.new }
  let(:search_term) { 'Gameofthrones' }
  let(:type) { 'recent' }

  describe '#search' do
    it 'searches by search term' do
      expect((engine.print_search search_term).size).to be > 0
    end

    it 'searches by search term' do
      expect((engine.get_tweets(search_term,type)).size).to be > 0
    end
  end

  describe '#features' do
    it 'returns the number of features given a hash of tweets' do
      tweets = engine.get_tweets(search_term,type)
      expect(engine.get_features(tweets).size).to be > 0
    end
  end

end
