require_relative '../test_helper'

include Weather::Translators

describe DDYTranslator do
  describe "#call" do
    it "should translate from the ddy source to the sink and apply a filter" do
      translator = DDYTranslator.new
      filter = Mock.new
      translator.filter = filter
      command = Mock.new
      translator.command = command
      translator.ddy_model = Object.new
      ddy_files = Object.new

      filter.expect :call, ddy_files, [translator.ddy_model]
      command.expect :call, nil, [ddy_files]

      translator.()

      assert filter.verify
      assert command.verify
    end
  end

  describe ".default_configuration" do
    it "should create a DDYTranslator, DDYFilter and load a DDY model" do
      ddy_path = Object.new
      translator = nil
      optional_ddy_model_mock = MiniTest::Mock.new
      ddy_model_mock = MiniTest::Mock.new
      model = Object.new

      optional_ddy_model_mock.expect :call, ddy_model_mock, [ddy_path]
      ddy_model_mock.expect :get, nil

      OpenStudio::EnergyPlus.stub :loadAndTranslateIdf, optional_ddy_model_mock, [ddy_path] do
        translator = DDYTranslator.default_configuration(model, ddy_path)
      end

      translator.must_be_instance_of DDYTranslator
      assert optional_ddy_model_mock.verify
      assert ddy_model_mock.verify
    end
  end
end
