module Weather
  module Commands
    class CreateStatFile
      attr_accessor :model

      def initialize(model)
        @model = model
      end

      def call(stat_file)
        water_temp = @model.getSiteWaterMainsTemperature
        water_temp.setAnnualAverageOutdoorAirTemperature(stat_file.mean_dry_bulb) if stat_file.mean_dry_bulb
        water_temp.setMaximumDifferenceInMonthlyAverageOutdoorAirTemperatures(stat_file.delta_dry_bulb) if stat_file.delta_dry_bulb
        climate_zones = model.getClimateZones
        climate_zones.clear
        climate_zones.setClimateZone('ASHRAE', stat_file.ashrae_climate_zone) if stat_file.ashrae_climate_zone
      end
    end
  end
end