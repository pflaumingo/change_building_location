module Weather
  module Models
    class DDYFilter
      def call(model)
        ddys = model.getObjectsByType('OS:SizingPeriod:DesignDay'.to_IddObjectType)
        filter_heating_ddys(ddys) + filter_cooling_ddys(ddys)
      end

      def filter_heating_ddys(ddys)
        htg_ddys = ddys.select {|ddy| ddy.name.get =~ /(99.6. Condns)/}
        htg_ddys = ddys.select {|ddy| ddy.name.get =~ /(99. Condns)/} if htg_ddys.empty?
        htg_ddys
      end

      def filter_cooling_ddys(ddys)
        clg_ddys = ddys.select {|ddy| ddy.name.get =~ /(.4. Condns)/}
        clg_ddys = ddys.select {|ddy| ddy.name.get =~ /(2. Condns)/} if clg_ddys.empty?
        clg_ddys
      end
    end
  end
end