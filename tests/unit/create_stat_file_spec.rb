require_relative '../test_helper'

include Weather::Commands

describe CreateStatFile do
  describe "#call" do
    it "correctly maps to OpenStudio when values are present" do
      model = OpenStudio::Model::Model.new
      mapper = CreateStatFile.new(model)
      stat_file = Minitest::Mock.new

      2.times do
        stat_file.expect :mean_dry_bulb, 15
        stat_file.expect :delta_dry_bulb, 30
        stat_file.expect :ashrae_climate_zone, "5B"
      end

      mapper.(stat_file)

      site_water = model.getSiteWaterMainsTemperature
      climate_zone = model.getClimateZones.getClimateZones("ASHRAE")[0]

      site_water.annualAverageOutdoorAirTemperature.get.must_equal 15
      site_water.maximumDifferenceInMonthlyAverageOutdoorAirTemperatures.get.must_equal 30
      climate_zone.institution.must_equal "ASHRAE"
      climate_zone.value.must_equal "5B"
    end

    it "doesn't map nil values" do
      model = OpenStudio::Model::Model.new
      mapper = CreateStatFile.new(model)
      stat_file = MiniTest::Mock.new

      2.times do
        stat_file.expect :mean_dry_bulb, nil
        stat_file.expect :delta_dry_bulb, nil
        stat_file.expect :ashrae_climate_zone, nil
      end

      mapper.(stat_file)

      site_water = model.getSiteWaterMainsTemperature
      site_water.annualAverageOutdoorAirTemperature.is_initialized.must_equal false
      site_water.maximumDifferenceInMonthlyAverageOutdoorAirTemperatures.is_initialized.must_equal false
      model.getClimateZones.numClimateZones.must_equal 0
    end
  end
end