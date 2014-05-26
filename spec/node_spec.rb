require 'spec_helper'

describe Node do

  let(:weights) { [1, 2, 3] }
  let(:inputs) { [1, 1, 1] }
  let(:node) { Node.new(weights, inputs) }

  before do
  end

  describe '#value' do
    it 'returns the right value' do
      value = node.value
      expect(value).to be 7
    end
  end

end
