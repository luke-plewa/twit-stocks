require 'spec_helper'

describe TwitterEngine do

  let(:engine) { TwitterEngine.new }
  let(:search_term) { 'Gameofthrones' }

  before do
    engine.setup
  end

  describe '#search' do
    it 'searches by search term' do
      expect((engine.print_search search_term).size).to be > 0
    end
  end

end
