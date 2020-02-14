module Weather
  module Mappers
    class StatFileMapper
      attr_accessor :data

      def initialize(data)
        @data = data
      end

      def self.from_path(path)
        begin
          File.open(path) do |file|
            data = file.read.force_encoding('ISO-8859-1')
            new(data)
          end
        rescue Errno::ENOENT => e
          raise e
        end
      end

      def get
        stat_file = Weather::Models::StatFile.new
        stat_file.monthly_dry_bulb = get_monthly_dry_bulb
        stat_file.ashrae_climate_zone = get_ashrae_climate_type
        stat_file
      end

      def get_monthly_dry_bulb
        # use regex to get the temperatures
        regex = /Daily Avg(.*)\n/
        match_data = @data.match(regex)

        return [] if match_data.nil?

        # first match is outdoor air temps
        monthly_temps = match_data[1].strip.split(/\s+/)
        monthly_temps.map(&:to_f)
      end

      def get_ashrae_climate_type
        regex = /Climate Zone \"(.*?)\" \(ASHRAE Standards?(.*)\)/
        match_data = @data.match(regex)

        return if match_data.nil?

        match_data[1].to_s.strip
      end
    end
  end
end

