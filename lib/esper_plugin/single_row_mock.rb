require 'java'
java_package 'is.tagomor.norikra.udf'

class SingleRowMock
  def self.passThrough(source)
    source
  end
end
