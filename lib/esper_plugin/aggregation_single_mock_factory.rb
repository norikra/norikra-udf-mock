require 'java'
java_package 'is.tagomor.norikra.udf'

java_import 'com.espertech.esper.client.hook.AggregationFunctionFactory'
java_import 'com.espertech.esper.epl.agg.service.AggregationValidationContext'
java_import 'com.espertech.esper.epl.agg.aggregator.AggregationMethod'

class AggregationSingleMockFactory
  java_implements 'AggregationFunctionFactory'

  java_signature 'public void setFunctionName(String)'
  def setFunctionName(functionName)
    # NOP
  end

  java_signature 'public void validate(AggregationValidationContext)'
  def validate(validationContext)
    if validationContext.getParameterTypes().length != 1 ||
       validationContext.getParameterTypes()[0] != java.lang.String.java_class
      raise java.lang.IllegalArgumentException.new("aggregation single mock requires a single parameter of type String")
    end
  end

  java_signature 'public Class getValueType()'
  def getValueType()
    java.lang.Long.java_class
  end

  java_signature 'public AggregationMethod newAggregator()'
  def newAggregator()
    Java::IsTagomorNorikraUdf::AggregationSingleMock.new
  end
end
