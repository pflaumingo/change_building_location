require_relative '../test_helper'
include Weather::Mappers

describe StatFileMapper do
  let(:root) { Pathname(__FILE__).dirname.join('..') }

  describe "#get_monthly_dry_bulb" do
    it "returns an array if data is found" do
      data = File.open("#{root}/fixtures/valid_weather_file.stat").read.force_encoding('ISO-8859-1')
      mapper = StatFileMapper.new(data)

      expected_result = [-4.6, -2.5, 3.8, 10.0, 15.3, 21.1, 24.1, 21.8, 18.1, 11.0, 4.7, -3.7]

      result = mapper.get_monthly_dry_bulb

      result.must_equal expected_result
    end

    it "returns an empty array if no data is found" do
      data = "Some incorrect data"
      mapper = StatFileMapper.new(data)

      expected_result = []

      result = mapper.get_monthly_dry_bulb

      result.must_equal expected_result
    end
  end

  describe "#get_ashrae_climate_type" do
    it "returns nil if the ASHRAE climate zone is not found" do
      data = "this is a purposefully incorrect string"
      mapper = StatFileMapper.new(data)

      result = mapper.send(:get_ashrae_climate_type)

      result.must_be_nil
    end

    it "returns a correct string if found" do
      data = " - Climate Zone \"5B\" (ASHRAE Standard 169-2013)\n"
      mapper = StatFileMapper.new(data)

      result = mapper.get_ashrae_climate_type

      result.must_equal "5B"
    end
  end

  describe "#get" do
    it "returns a new StatFile" do
      data = "This doesn't matter"
      mapper = StatFileMapper.new(data)

      result = mapper.get

      result.must_be_instance_of Weather::Models::StatFile
    end
  end

  describe ".from_path" do
    it "returns a new mapper when path is valid" do
      path = "#{root}/fixtures/valid_weather_file.stat"

      mapper = StatFileMapper.from_path(path)

      mapper.must_be_instance_of Weather::Mappers::StatFileMapper
    end

    it "raises an exception if the path is invalid" do
      path = "this isn't a valid path"

      proc { StatFileMapper.from_path(path) }.must_raise Errno::ENOENT
    end
  end
end