require 'java'
require 'norikra/udf'

module Norikra
  module UDF
    class PassThrough < Norikra::UDF::SingleRow
      def self.init
        require 'norikra-udf-mock.jar'
      end

      def definition
        # function_name, Java Class Name (fqdn),                static function name
        ["passThrough", "is.tagomor.norikra.udf.SingleRowMock", "passThrough"]
      end
    end

    class Upcase < Norikra::UDF::SingleRow
      def self.init
        require 'norikra-udf-mock.jar'
      end

      def definition
        ["upcase", "is.tagomor.norikra.udf.CaseSwitchMock", "upcase"]
      end
    end

    class Downcase < Norikra::UDF::SingleRow # 2 function from 1 class
      def self.init
        require 'norikra-udf-mock.jar'
      end

      def definition
        ["downcase", "is.tagomor.norikra.udf.CaseSwitchMock", "downcase"]
      end
    end

    class CountLength < Norikra::UDF::AggregationSingle
      def self.init
        require 'norikra-udf-mock.jar'
      end

      def definition
        # function name   UDAF Factory Class Name
        ["countLength", "is.tagomor.norikra.udf.AggregationSingleMockFactory"]
      end
    end

    class CountBytes < Norikra::UDF::AggregationSingle
      def self.init
        require 'norikra-udf-mock.jar'
      end

      def definition
        ["countBytes", "is.tagomor.norikra.udf.CountBytesMockFactory"]
      end
    end
  end
end
