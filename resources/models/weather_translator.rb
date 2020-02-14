module Weather
  module Models
    class WeatherTranslator
      attr_accessor :translators

      def initialize
        @translators = []
      end

      def self.default_configuration(model, epw_path, ddy_path, stat_path)
        translator = self.new
        translator.translators << Weather::Translators::DDYTranslator.default_configuration(model, ddy_path)
        translator.translators << Weather::Translators::EPWTranslator.default_configuration(model, epw_path)
        translator.translators << Weather::Translators::StatTranslator.default_configuration(model, stat_path)
        translator
      end

      def call
        @translators.map { |translator| translator.()  }
      end
    end
  end
end