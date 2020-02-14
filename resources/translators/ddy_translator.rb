module Weather
  module Translators
    class DDYTranslator
      attr_accessor :ddy_model, :filter, :command

      def self.default_configuration(model, ddy_path)
        translator = self.new
        translator.ddy_model = OpenStudio::EnergyPlus.loadAndTranslateIdf(ddy_path).get
        translator.command = Weather::Commands::CreateDDY.new(model)
        translator.filter = Weather::Models::DDYFilter.new
        translator
      end

      def call
        ddy_files = @filter.(@ddy_model)
        @command.(ddy_files)
      end
    end
  end
end