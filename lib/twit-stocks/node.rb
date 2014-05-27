class Node

  attr_accessor :weights, :inputs

  def initialize inputs, weights
    self.weights = weights
    self.weights << 1 # bias unit weight
    self.inputs = inputs
    self.inputs << 1 # bias unit
  end

  def value
    value = 0
    inputs.each_with_index do |input, index|
      value += weights[index] * input
    end
    value
  end

end
