# Norikra::UDF Mocks

This repository is a example of Norikra UDF plugin.

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
rbenv local jruby-1.7.4
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
  * Write java code in `java` directory (ex: `java/org/example/norikra/udf/MyFunction.java`)
  * Write norikra plugin definitions in `lib` directory (ex: `lib/norikra/udf/my_function.rb`)
  * Write specs in `spec` with `require "norikra/udf_spec_helper"`
6. Compile java code and run rspecs
```
bundle
bundle exec rake compile
bundle exec rake spec
 # bundle exec rake test #== bundle exec rake compile && bundle exec rake spec
```
7. Run norikra-server with your UDF, and test it
```
bundle exec norikra-server start --more-verbose
```
8. Commit && Plugin release to rubygem.org
```
 # git add && git commit ...
bundle exec rake release
```

## UDF code and tests

### Single-Row UDF

TODO: write

### Aggregation Function UDF

TODO: write

### Aggregation Multi-Function UDF

Aggregation Multi-Function UDF of Esper is not supported yet (Norikra v0.0.8).

## Copyright

* Copyright (c) 2013- TAGOMORI Satoshi (tagomoris)
* License
  * GPL v2
