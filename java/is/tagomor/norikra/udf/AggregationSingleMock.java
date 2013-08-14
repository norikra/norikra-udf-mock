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

    Object[] params = (Object[]) value;
    for (Object o : params) {
    // for (int i = 0; params.length; i++) {
      //counter += params[i].toString().length;
      counter += o.toString().length();
    }
  }

  public void leave(Object value) {
    if (value == null)
      return;

    Object[] params = (Object[]) value;
    for (int i = 0; i < params.length; i++) {
      counter -= params[i].toString().length();
    }
  }

  public Object getValue() {
    return counter;
  }

  public void clear() {
    counter = 0;
  }
}


