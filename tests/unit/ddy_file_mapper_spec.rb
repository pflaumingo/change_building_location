require_relative '../test_helper'
include Weather::Commands

describe CreateDDY do

  describe "#call" do
    it "maps ddys to the model" do
      model = Mock.new
      mapper = CreateDDY.new(model)
      ddys = [Object.new, Object.new]

      (0..1).each do |i|
        model.expect :addObject, nil, [ddys[i]]
      end

      mapper.(ddys)

      assert model.verify
    end
  end
end