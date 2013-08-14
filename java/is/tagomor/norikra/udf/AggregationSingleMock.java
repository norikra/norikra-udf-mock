package is.tagomor.norikra.udf;

import com.espertech.esper.epl.agg.aggregator.AggregationMethod;

// import java.util.Map;

public class AggregationSingleMock implements AggregationMethod {
  // private final static long = 16777216;
  private long counter;

  public AggregationSingleMock() {
    counter = 0;
  }

  public Class getValueType() {
    return Long.class;
  }

  public void enter(Object value) {
    if (value == null)
      return;

    counter += value.toString().length();
  }

  public void leave(Object value) {
    counter -= value.toString().length();
  }

  public Object getValue() {
    return counter;
  }

  public void clear() {
    counter = 0;
  }
}


