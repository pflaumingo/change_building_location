module Weather
  module Models
    class StatFile
      attr_accessor :monthly_dry_bulb, :ashrae_climate_zone

      def initialize()
        @monthly_dry_bulb = []
      end

      def mean_dry_bulb
        @monthly_dry_bulb.reduce(&:+) / @monthly_dry_bulb.size unless @monthly_dry_bulb.empty?
      end

      def delta_dry_bulb
        @monthly_dry_bulb.max - @monthly_dry_bulb.min unless @monthly_dry_bulb.empty?
      end
    end
  end
end