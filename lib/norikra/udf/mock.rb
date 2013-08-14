require 'java'
require 'norikra/udf'

module Norikra
  module UDF
    class PassThrough < Norikra::UDF::SingleRow
      def self.init
        require 'norikra-udf-mock.jar'
      end
      def definition
        ["passThrough", "is.tagomor.norikra.udf.SingleRowMock", "passThrough"]
      end
    end

    class CountLength < Norikra::UDF::AggregationSingle
      def self.init
        require 'norikra-udf-mock.jar'
      end
      def definition
        ["countLength", "is.tagomor.norikra.udf.AggregationSingleMockFactory"]
      end
    end
  end
end
