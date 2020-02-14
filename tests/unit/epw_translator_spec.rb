require_relative '../test_helper'

include Weather::Translators

describe EPWTranslator do
  describe "#call" do
    it "should translate from the epw source to the sink" do
      translator = EPWTranslator.new
      translator.model = Object.new
      translator.epw_file = Object.new
      mock = MiniTest::Mock.new

      mock.expect :call, nil, [translator.model, translator.epw_file]

      OpenStudio::Model::WeatherFile.stub :setWeatherFile, mock, [translator.model, translator.epw_file] do
        translator.()
      end

      assert mock.verify
    end
  end

  describe '.default_configuration' do
    it "should create an EPWTranslator and load an EpwFile" do
      epw_path = Object.new
      translator = nil
      optional_epwfile_mock = MiniTest::Mock.new
      epwfile_mock = MiniTest::Mock.new
      model = Object.new

      optional_epwfile_mock.expect :call, epwfile_mock, [epw_path]
      epwfile_mock.expect :get, nil

      OpenStudio::EpwFile.stub :load, optional_epwfile_mock, [epw_path] do
        translator = EPWTranslator.default_configuration(model, epw_path)
      end

      translator.must_be_instance_of EPWTranslator
      translator.model.must_equal model
      assert optional_epwfile_mock.verify
      assert epwfile_mock.verify
    end
  end
end
