require_relative '../test_helper'

include Weather::Models

describe DDYFilter do
  describe "#call" do
    it "gets the filtered ddys" do
      filter = DDYFilter.new
      model = Mock.new

      model.expect :getObjectsByType, [], ['OS:SizingPeriod:DesignDay'.to_IddObjectType]

      ddys = filter.(model)

      model.verify
      ddys.must_be_instance_of Array
    end
  end

  describe "#filter_heating_ddys" do
    it "returns only the 99.6% design days" do
      filter = DDYFilter.new
      model = OpenStudio::Model::Model.new
      ddy_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_expected.setName("Chicago Ohare Intl Ap Ann Htg 99.6% Condns DB")
      ddy_not_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_not_expected.setName("Chicago Ohare Intl Ap Ann Htg 99% Condns DB")

      result = filter.filter_heating_ddys([ddy_expected, ddy_not_expected])

      result.size.must_equal 1
      result[0].must_equal ddy_expected
    end

    it "returns the 99% design days" do
      filter = DDYFilter.new
      model = OpenStudio::Model::Model.new
      ddy_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_expected.setName("Chicago Ohare Intl Ap Ann Htg 99% Condns DB")

      result = filter.filter_heating_ddys([ddy_expected])

      result.size.must_equal 1
      result[0].must_equal ddy_expected
    end
  end

  describe "#filter_cooling_ddys" do
    it "returns only the 0.4% design days" do
      filter = DDYFilter.new
      model = OpenStudio::Model::Model.new
      ddy_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_expected.setName("Chicago Ohare Intl Ap Ann Htg .4% Condns DB")
      ddy_not_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_not_expected.setName("Chicago Ohare Intl Ap Ann Htg 2% Condns DB")

      result = filter.filter_cooling_ddys([ddy_expected, ddy_not_expected])

      result.size.must_equal 1
      result[0].must_equal ddy_expected
    end

    it "returns the 2% design days" do
      filter = DDYFilter.new
      model = OpenStudio::Model::Model.new
      ddy_expected = OpenStudio::Model::DesignDay.new(model)
      ddy_expected.setName("Chicago Ohare Intl Ap Ann Htg 2% Condns DB")

      result = filter.filter_cooling_ddys([ddy_expected])

      result.size.must_equal 1
      result[0].must_equal ddy_expected
    end
  end
end
