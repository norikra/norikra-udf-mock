# Norikra::UDF Mocks

This repository is a example of Norikra UDF plugin.

Norikra UDF plugin gem can contain some UDFs/UDAFs.

UDFs/UDAFs implementations can be written in both of Ruby(JRuby) and Java.
 * Java UDFs can be written with external libraries in `jar/` directory
 * Ruby code are converted into Java, so external ruby gems cannot be used, but java libraries from `jar/` can be loaded.

One gem can contain both of Java origin UDFs and JRuby origin UDFs at the same time.

## Steps to write/release your UDF plugin

1. Install JRuby and Bundler
```
rbenv install jruby-1.7.4
rbenv shell jruby-1.7.4
rbenv rehash
gem install bundler
rbenv rehash
```
2. Generate repository
```
bundle gem norikra-udf-yours
cd norikra-udf-users
rbenv local jruby-1.7.11
```
3. Copy Rakefile from norikra-udf-mock repository (to make .jar of your plugin)
  * And add some directories
```
cp ../norikra-udf-mock/Rakefile ./
mkdir spec jar java
```
4. Edit gemspec
  * Add `spec.platform = "java"`
  * Add `jar` to `spec.require_paths`
  * Add `norikra` to `spec.add_runtime_dependency`
  * Add `bundler`, `rake` and `rspec` to `spec.add_runtime_dependency`
  * Edit other fields
5. Write UDFs
  * see `Writing UDF and tests`
6. Compile java code and run rspecs
```
bundle
bundle exec rake compile
bundle exec rake spec
 # bundle exec rake test #== bundle exec rake compile && bundle exec rake spec
```
7. Run norikra-server with your UDF, and test it
```
bundle exec norikra start --more-verbose
```
8. Commit && Plugin release to rubygem.org
```
 # git add && git commit ...
bundle exec rake all
bundle exec rake release
```

## Writing UDF and tests

Example codes are for `norikra-udf-myudf`.

### UDF definitions

UDFs/UDAFs definitions are written by Ruby(JRuby) code. These files are placed as `lib/norikra/udf/your_udf.rb`. No suffixes like `_defs` are required for filename.

Definition class should have 2 methods.
 * `.init`
   * code to load UDF impelementations, and dependencies if exists.
   * `require 'norikra-udf-myudf.jar'` is required
   * `require 'your-dependency.jar'`s are options
 * `#definition`
   * returns UDF definition as array
     1. first element is the name of UDF in queries
     1. second element is the FQDN class name of UDF implementation (even if w/ JRuby code)
     1. third element is static method name of UDF implementation (DO NOT specify this for UDAF)

For example:

```ruby
 # in lib/norikra/myudf.rb
require 'java'
require 'norikra/udf'

module Norikra
  module UDF
    
    # single row UDF
    class MyUDF1 < Norikra::UDF::SingleRow
      # class method
      def self.init
        require 'norikra-udf-myudf.jar'
      end

      # instance method
      def definition
        # function_name, Java Class Name (fqdn),    static function name
        ["myudf1", "org.example.yourcompany.norikra.udf.MyUDF1", "execute"]
      end
    end
    
    # simple UDAF
    class MyUDAF2 < Norikra::UDF::AggregationSingle
      def self.init
        require 'norikra-udf-myudf.jar'
        require 'my-dependencies.jar'
      end

      def definition
        # function name, UDAF Factory Class Name
        ["myudf2", "org.example.yourcompany.norikra.udf.MyUDAF2Factory"]
      end
    end
  end
end
```

UDF/UDAF implementations are written in whether JRuby or Java, but definition code have same style like just above for both.

### UDF code by JRuby

UDF implementations are placed on `lib/esper_plugin/*.rb`. Don't make sub directories.

Only a UDF/UDAF implementation can be written in one file, and all files must have a `java_package` definition.

```ruby
require 'java'
java_package 'org.example.yourcompany.norikra.udf'

class MyUDF1  # FQDN: org.example.yourcompany.norikra.udf.MyUDF1
  def execute(source)
    1         # always returns number 1
  end
end
```

UDF implementation classes can contain 2 or more functions.

### UDAF (aggregation function) code by JRuby

UDAF implementations are also placed on `lib/esper_plugin/*.rb` and UDAF requires 2 files, implementation and its factory.

At first, write implementation class on `lib/esper_plugin/myudaf2.rb`:

```ruby
require 'java'
java_package 'org.example.yourcompany.norikra.udf'

java_import 'com.espertech.esper.epl.agg.aggregator.AggregationMethod'

 # and more 'java_import' for your java dependency
 
class MyUDAF2
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
    
    @counter += 1
  end
  
  java_signature 'public void leave(Object)'
  def leave(value)
    @counter -= 1
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
```

`java_implements` and `java_signature` are required. For UDAF, all classes and methods must have these definitions.


Implementation classes must have 6 methods:

 * `initialize`
   * constructor method to initialize internal state
 * `getValueType`
   * java class of this function's return value
 * `enter(value)`
   * the method called when new value comes in specified window
 * `leave(value)`
   * the method called when a value will be expired from specified window
   * after `instance.enter(val1) ; instance.leave(val1)`, internal state should return previous one
 * `getValue`
   * a method to return current value of this function (should have no side effect)
 * `clear`
   * method to re-initialize internal state

Next, write factory class:

```ruby
require 'java'
java_package 'org.example.yourcompany.norikra.udf'
 
java_import 'com.espertech.esper.client.hook.AggregationFunctionFactory'
java_import 'com.espertech.esper.epl.agg.service.AggregationValidationContext'
java_import 'com.espertech.esper.epl.agg.aggregator.AggregationMethod'
 
 # and more 'java_import' for your java dependency
 
class MyUDAF2Factory
  java_implements 'MyUDAF2Factory'
  
  java_signature 'public void setFunctionName(String)'
  def setFunctionName(functionName)
    # NOP
  end
  
  java_signature 'public void validate(AggregationValidationContext)'
  def validate(validationContext)
    if validationContext.getParameterTypes().length != 1 ||
       validationContext.getParameterTypes()[0] != java.lang.Long.java_class
      raise java.lang.IllegalArgumentException.new("myudf2 is for Long type")
    end
  end
  
  java_signature 'public Class getValueType()'
  def getValueType()
    java.lang.Long.java_class
  end
  
  java_signature 'public AggregationMethod newAggregator()'
  def newAggregator()
    # return JRuby instance of UDAF implementation
    Java::OrgExampleYourcompanyNorikraUdf::MyUDAF2.new
  end
end
```

Factory class must have 4 instance methods:

 * `setFunctionName(name)`
   * set requirements for function instance from function name
   * use this only if 2 or more functions share one implementation (and its factory) class.
 * `validate(validation_context)`
   * validate UDAF arguments to make error on query registration if queries have unexpected arguments
 * `getValueType`
   * returns java class which this UDAF `#getValue` implementation returns (same with implementation class's `getValueType`)
 * `newAggregator`
   * returns an instance of UDAF class which properly instanciated

These classes are converted into java code on `java/` when `bundle exec rake compile` executed.

### UDF code by Java

UDF implementations are placed on `src/**/*.java` (ex: `src/org/example/yourcompany/norikra/udf/MyUDF1.java`). Directories MUST be created properly for your own java packages.

```java
// src/org/example/yourcompany/norikra/udf/MyUDF1.java

package org.example.norikra.udf;

public final class MyUDF1
{
  public static String execute(final String source)
  {
    return 1;
  }
}
```

UDF implementation classes can contain 2 or more functions, as same with JRuby implementations.

### UDAF (aggregation function) code by Java

See `UDAF (aggregation function) code by JRuby` above for what to write. Code is very simple. At first, write implementation class:

```java
// src/org/example/yourcompany/norikra/udf/MyUDAF2.java

package org.example.yourcompany.norikra.udf;

import com.espertech.esper.epl.agg.aggregator.AggregationMethod;

public class MyUDAF2 implements AggregationMethod {
  private long counter;

  public MyUDAF2() {
    counter = 0;
  }

  public Class getValueType() {
    return Long.class;
  }

  public void enter(Object value) {
    if (value == null)
      return;

    counter += 1;
  }

  public void leave(Object value) {
    counter -= 1;
  }

  public Object getValue() {
    return counter;
  }

  public void clear() {
    counter = 0;
  }
}
```

And next, write factory class:

```java
// src/org/example/yourcompany/norikra/udf/MyUDAF2.java

package org.example.yourcompany.norikra.udf;

import com.espertech.esper.client.hook.AggregationFunctionFactory;
import com.espertech.esper.epl.agg.service.AggregationValidationContext;
import com.espertech.esper.epl.agg.aggregator.AggregationMethod;

import org.example.yourcompany.norikra.udf.MyUDAF2;

public class MyUDAF2Factory implements AggregationFunctionFactory {
  public void setFunctionName(String functionName) {
    // no action taken
  }

  public void validate(AggregationValidationContext validationContext) {
    if ((validationContext.getParameterTypes().length != 1) ||
        (validationContext.getParameterTypes()[0] != Long.class)) {
      throw new IllegalArgumentException("query resistration error message");
    }

    if (validationContext.isDistinct())
      throw new IllegalArgumentException("this function does not support DISTINCT");
  }

  public Class getValueType() {
    return Long.class;
  }

  public AggregationMethod newAggregator() {
    return new MyUDAF2();
  }
}
```

These classes are compiled and placed on `java/` with JRuby origin code, when `bundle exec rake compile` executed.

### Writing tests

To write tests of UDFs/UDAFs, use RSpec and helper library that norikra has. With this helper, we can write specs in same way for both of Java origin UDFs and JRuby origin UDFs.

Spec files are written on `spec/**/*_spec.rb`. All specs will be checked on `bundle exec rake spec` (or `test`, `all`).

At first, all specs should have these code on header:

```ruby
require 'norikra/udf_spec_helper'

include Norikra::UDFSpecHelper

require 'norikra/udf/myudf' # this is your UDF definition file
```

And then, write specs.

```ruby
# for single row UDF
describe Norikra::UDF::MyUDF1 do
  udf_function Norikra::UDF::MyUDF1

  it 'always returns numeric 1' do
    source = "xxx yyy zzz"
    r = fcall(:myudf1, source)
    expect(r).to eql(1)

    expect(fcall(:myudf1, "tagomoris")).to eql(1)
  end
end
```

`udf_function` directive must be written in `describe` block to declare the function class to be tested.

For single row udf, `fcall` method receives function name and its arguments, and returns its result.

About testing of aggregate functions, code are more complex a litte:

```ruby
describe Norikra::UDF::MyUDAF2 do
  udf_function Norikra::UDF::MyUDAF2, :valueType => java.lang.Long, :parameters => [[java.lang.Long]]

  it 'returns Long' do
    expect(fcall(:countBytes, :getValueType)).to eql(java.lang.Long.java_class)
  end

  it 'counts of input times' do
    f = function(:myudf2) # create instance of aggregate function

    f._call(:enter, 1) # == "f.enter(1)"
    f._call(:enter, 100) # == "f.enter(100)"

    expect(f.getvalue).to eql(2)

    f._call(:leave, 1) # == "f.leave(1)"

    expect(f._call(:getvalue)).to eql(1)

    f.clear
    expect(f.getValue).to eql(0)
  end
end
```

For aggregate functions, `udf_function` receives some options:

 * `valueType` (required)
   * java class of function's return values
 * `parameters` (required)
   * list of definitions of parameters: `[defs, ... ]`
   * definition element is `[parameteType, boolean_constant, constant_values]`
     * `boolean_constant`: indicate whether a contant value is specified on this parameter, or not
     * `constant_values`: constant values which specified for this parameter in a query
   * 2nd and 3rd element is optional, and default value is `false` and `nil` (this parameter is variable field).
 * `distinct` (optional)
   * if true, `DISTINCT` specified (default `false`).
 * `windowed` (optional)
   * if true, all parameters come from stream, and remove from stream (default `true`).

### Aggregation Multi-Function UDF

Aggregation Multi-Function UDF of Esper is not supported in current version of Norikra (`v1.0.0`).

## Copyright

* Copyright (c) 2013- TAGOMORI Satoshi (tagomoris)
* License
  * GPL v2
