require_relative 'resources/weather'

class ChangeBuildingLocation < OpenStudio::Measure::ModelMeasure

  def name
    'ChangeBuildingLocation'
  end

  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    weather_file_name = OpenStudio::Measure::OSArgument.makeStringArgument('weather_file_name', true)
    weather_file_name.setDisplayName('Weather File Name')
    weather_file_name.setDescription('Name of the weather file to change to. This is the filename with the extension (e.g. NewWeather.epw). Optionally this can inclucde the full file path, but for most use cases should just be file name.')

    args << weather_file_name
    args
  end

  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    weather_file_name = runner.getStringArgumentValue("weather_file_name", user_arguments)
    weather_file_path = runner.workflow.findFile(weather_file_name).get

    # get epw file path
    epw_path, ddy_path, stat_path = ChangeBuildingLocation.create_weather_file_paths(weather_file_path.to_s)

    translator = Weather::Models::WeatherTranslator.default_configuration(model, epw_path, ddy_path, stat_path)

    translator.()
    true
  end

  def self.create_weather_file_paths(path)
    epw_path = "#{File.join(File.dirname(path), File.basename(path, '.*'))}.epw"
    ddy_path = "#{File.join(File.dirname(path), File.basename(path, '.*'))}.ddy"
    stat_path = "#{File.join(File.dirname(path), File.basename(path, '.*'))}.stat"

    return epw_path, ddy_path, stat_path
  end
end

# This allows the measure to be use by the application
ChangeBuildingLocation.new.registerWithApplication