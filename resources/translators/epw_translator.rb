module Weather
  module Translators
    class EPWTranslator
      attr_accessor :model, :epw_file

      def self.default_configuration(model, epw_path)
        translator = self.new
        translator.model = model
        translator.epw_file = OpenStudio::EpwFile.load(epw_path).get
        translator
      end

      def call
        OpenStudio::Model::WeatherFile.setWeatherFile(@model, @epw_file)
      end
    end
  end
end