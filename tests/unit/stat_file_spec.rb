require_relative '../test_helper'
include Weather::Models

describe StatFile do
  describe "#mean_dry_bulb" do
    it "calculates the average if valid" do
      stat_file = StatFile.new
      stat_file.monthly_dry_bulb = [0,1,2,3,4,5,6,7,8,9,10,11]

      mean_dry_bulb = stat_file.mean_dry_bulb

      mean_dry_bulb.must_equal 5.0
    end

    it "returns nil if invalid" do
      stat_file = StatFile.new
      stat_file.monthly_dry_bulb = []

      mean_dry_bulb = stat_file.mean_dry_bulb
      mean_dry_bulb.must_be_nil
    end
  end

  describe "#delta_dry_bulb" do
    it "calculates the delta if valid" do
      stat_file = StatFile.new
      stat_file.monthly_dry_bulb = [0,1,2,3,4,5,6,7,8,9,10,11]

      delta_dry_bulb = stat_file.delta_dry_bulb

      delta_dry_bulb.must_equal 11.0
    end

    it "returns nil if invalid" do
      stat_file = StatFile.new
      stat_file.monthly_dry_bulb = []

      delta_dry_bulb = stat_file.delta_dry_bulb

      delta_dry_bulb.must_be_nil
    end
  end
end