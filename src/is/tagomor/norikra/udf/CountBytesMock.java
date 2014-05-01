package is.tagomor.norikra.udf;

import com.espertech.esper.epl.agg.aggregator.AggregationMethod;

public class CountBytesMock implements AggregationMethod {
  private long counter;

  public CountBytesMock() {
    counter = 0;
  }

  public Class getValueType() {
    return Long.class;
  }

  public void enter(Object value) {
    if (value == null)
      return;

    counter += value.toString().getBytes().length;
  }

  public void leave(Object value) {
    counter -= value.toString().getBytes().length;
  }

  public Object getValue() {
    return counter;
  }

  public void clear() {
    counter = 0;
  }
}
