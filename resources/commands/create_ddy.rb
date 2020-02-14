module Weather
  module Commands
    class CreateDDY
      attr_accessor :model

      def initialize(model)
        @model = model
      end

      def call(ddys)
        ddys.each { |ddy| model.addObject(ddy) }
      end
    end
  end
end