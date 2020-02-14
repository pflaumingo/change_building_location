module Weather
  module Translators
    class StatTranslator
      attr_accessor :mapper, :command

      def self.default_configuration(model, stat_path)
        translator = self.new
        translator.mapper = Weather::Mappers::StatFileMapper.from_path(stat_path)
        translator.command = Weather::Commands::CreateStatFile.new(model)
        translator
      end

      def call
        stat_file = mapper.get
        command.(stat_file)
      end
    end
  end
end