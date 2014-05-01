package is.tagomor.norikra.udf;

import com.espertech.esper.client.hook.AggregationFunctionFactory;
import com.espertech.esper.epl.agg.service.AggregationValidationContext;
import com.espertech.esper.epl.agg.aggregator.AggregationMethod;

import is.tagomor.norikra.udf.CountBytesMock;

public class CountBytesMockFactory implements AggregationFunctionFactory {
  /*
    The aggregation function factory instance receives the aggregation function name via set setFunctionName method.
   */
  public void setFunctionName(String functionName) {
    // no action taken
  }

  /*
    An aggregation function factory must provide an implementation of the validate method
    that is passed a AggregationValidationContext validation context object.
    Within the validation context you find the result type of each of the parameters expressions
    to the aggregation function as well as information about constant values and data window use.
    Please see the JavaDoc API documentation for a comprehensive list of validation context information.

    Since the example concatenation function requires string types, it implements a type check:
   */
  public void validate(AggregationValidationContext validationContext) {
    if ((validationContext.getParameterTypes().length != 1) ||
        (validationContext.getParameterTypes()[0] != String.class)) {
      throw new IllegalArgumentException("countBytes mock requires a single parameter of type String");
    }
  }

  /*
    In order for the engine to validate the type returned by the aggregation function against
    the types expected by enclosing expressions, the getValueType must return the result type
    of any values produced by the aggregation function:
   */
  public Class getValueType() {
    return Long.class;
  }

  /*
    Finally the factory implementation must provide a newAggregator method that returns instances
    of AggregationMethod. The engine invokes this method for each new aggregation state to be allocated.
   */
  public AggregationMethod newAggregator() {
    return new CountBytesMock();
  }
}
