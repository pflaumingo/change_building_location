require_relative '../test_helper'

include Weather::Translators

describe StatTranslator do
  describe "#call" do
    it "should translate from the stat source to the sink" do
      translator = StatTranslator.new
      mapper = Mock.new
      translator.mapper = mapper
      command = Mock.new
      translator.command = command
      stat_file = Object.new

      mapper.expect :get, stat_file
      command.expect :call, nil, [stat_file]

      translator.()

      assert mapper.verify
      assert command.verify
    end
  end

  describe ".default_configuration" do
    it "should configure a StatFileMapper and CreateStatFile command" do
      stat_path = Object.new
      model = Object.new
      translator = nil
      mapper = Object.new

      Weather::Mappers::StatFileMapper.stub :from_path, mapper, [stat_path] do
        translator = StatTranslator.default_configuration(model, stat_path)
      end

      translator.must_be_instance_of StatTranslator
      translator.command.must_be_instance_of Weather::Commands::CreateStatFile
    end
  end
end
