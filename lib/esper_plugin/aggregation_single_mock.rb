require 'java'
java_package 'is.tagomor.norikra.udf'

java_import 'com.espertech.esper.epl.agg.aggregator.AggregationMethod'

class AggregationSingleMock
  java_implements 'AggregationMethod'

  def initialize
    @counter = 0
  end

  java_signature 'public Class getValueType()'
  def getValueType()
    java.lang.Long.java_class
  end

  java_signature 'public void enter(Object)'
  def enter(value)
    if value == nil
      return
    end

    @counter += value.to_s.length
  end

  java_signature 'public void leave(Object)'
  def leave(value)
    @counter -= value.to_s.length
  end

  java_signature 'public Object getValue()'
  def getValue()
    @counter
  end

  java_signature 'public void clear()'
  def clear()
    @counter = 0
  end
end
