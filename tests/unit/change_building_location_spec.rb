require_relative '../test_helper'

describe ChangeBuildingLocation do
  describe ".create_weather_file_paths" do
    it "should return an epw, ddy and stat path" do
      input_path = "/random/dir/weather_file_path.epw"
      expected_epw_path = "/random/dir/weather_file_path.epw"
      expected_ddy_path = "/random/dir/weather_file_path.ddy"
      expected_stat_path = "/random/dir/weather_file_path.stat"

      epw, ddy, stat = ChangeBuildingLocation.create_weather_file_paths(input_path)

      epw.must_equal expected_epw_path
      ddy.must_equal expected_ddy_path
      stat.must_equal expected_stat_path
    end
  end

  describe "#run" do
    it "parses the arguments, creates and runs a translator" do
      measure = ChangeBuildingLocation.new
      runner, workflow, translator, file = Mock.new, Mock.new, Mock.new, Mock.new
      user_arguments, model, epw_path, ddy_path, stat_path = Object.new, OpenStudio::Model::Model.new, Object.new, Object.new, Object.new
      weather_file_name, weather_file_path = Object.new, Object.new

      runner.expect :getStringArgumentValue, weather_file_name, ["weather_file_name", user_arguments]
      runner.expect :workflow, workflow
      workflow.expect :findFile, file, [weather_file_name]
      file.expect :get, weather_file_path
      translator.expect :call, nil

      class OpenStudio::Measure::ModelMeasure
        def run(model, runner, user_arguments)
        end
      end

      ChangeBuildingLocation.stub :create_weather_file_paths, [epw_path, ddy_path, stat_path] do
        Weather::Models::WeatherTranslator.stub :default_configuration, ->(*args) {translator} do
          measure.run(model, runner, user_arguments)
        end
      end

      assert runner.verify
      assert workflow.verify
      assert translator.verify
    end
  end
end