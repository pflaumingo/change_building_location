require_relative '../test_helper'

include Weather::Translators

describe WeatherTranslator do
  describe "#initialize" do
    it "initializes with an empty array of translators" do
      translator = Weather::Models::WeatherTranslator.new()

      translator.translators.must_be_instance_of Array
    end
  end

  describe "#call" do
    it "calls each translator" do
      translator = WeatherTranslator.new()
      mock_translator_1 = Mock.new
      mock_translator_2 = Mock.new

      translator.translators << mock_translator_1
      translator.translators << mock_translator_2

      mock_translator_1.expect :call, nil
      mock_translator_2.expect :call, nil

      translator.()

      assert mock_translator_1.verify
      assert mock_translator_2.verify
    end
  end

  describe ".default_configuration" do
    #it "creates a translator with a DDY, EPW and Stat configured" do
    #  model, epw_path, ddy_path, stat_path = Object.new, Object.new, Object.new, Object.new
    #
    #  translator = WeatherTranslator.default_configuration(model, epw_path, ddy_path, stat_path)
    #end
  end
end