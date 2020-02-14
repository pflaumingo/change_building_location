require_relative '../test_helper'
require 'open3'

describe ChangeBuildingLocation do
  let(:root) { Pathname(__FILE__).dirname.join('..') }

  it "runs the measure successfully when valid paths are specified" do
    measure = ChangeBuildingLocation.new
    weather_file_name = File.join(root, "/fixtures/valid_weather_file.epw")
    osw_path = "/Users/npflaum/Documents/GitHub/InsightStudioMeasures/measures/ChangeBuildingLocation/tests/fixtures/valid.osw"
    osw = OpenStudio::WorkflowJSON.load(osw_path).get
    runner = OpenStudio::Measure::OSRunner.new(osw)
    model = OpenStudio::Model::Model.new
    arguments =  measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    new_arg = OpenStudio::Measure::OSArgument.new("weather_file_name", OpenStudio::Measure::OSArgumentType.new("String"), false, false)
    new_arg.setValue(weather_file_name)
    argument_map["weather_file_name"] = new_arg

    result = measure.run(model, runner, argument_map)

    assert result
  end

  it "fails ungracefully when an invalid path is provided" do
    measure = ChangeBuildingLocation.new
    weather_file_name = File.join(root, "/fixtures/asdf.epw")
    osw_path = "/Users/npflaum/Documents/GitHub/InsightStudioMeasures/measures/ChangeBuildingLocation/tests/fixtures/valid.osw"
    osw = OpenStudio::WorkflowJSON.load(osw_path).get
    runner = OpenStudio::Measure::OSRunner.new(osw)
    model = OpenStudio::Model::Model.new
    arguments =  measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    new_arg = OpenStudio::Measure::OSArgument.new("weather_file_name", OpenStudio::Measure::OSArgumentType.new("String"), false, false)
    new_arg.setValue(weather_file_name)
    argument_map["weather_file_name"] = new_arg

    proc { measure.run(model, runner, argument_map) }.must_raise RuntimeError

  end
end