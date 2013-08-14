require 'norikra/udf_spec_helper'

include Norikra::UDFSpecHelper

require 'norikra/udf/mock'

describe Norikra::UDF::PassThrough do
  udf_function Norikra::UDF::PassThrough

  it 'returns argument itself' do
    source = "xxx yyy zzz"
    r = fcall(:passThrough, source)
    expect(r).to eql(source)
  end
end

describe Norikra::UDF::CountLength do
  udf_function Norikra::UDF::CountLength, :valueType => java.lang.Long, :parameters => [[java.lang.String]]

  it 'returns Long' do
    expect(fcall(:countLength, :getValueType)).to eql(java.lang.Long.java_class)
  end

  it 'counts sum of length of Strings' do
    f = function(:countLength)

    f._call(:enter, "01234")
    f._call(:enter, "56789")
    f._call(:enter, "01234")
    f._call(:enter, "56789")
    v = f.getValue
    expect(v).to eql(20)
    f._call(:clear)
    expect(f._call(:getValue)).to eql(0)
  end

  it 'can decrements count with leave' do
    expect(fcall(:countLength, :getValue)).to eql(0)
    fcall(:countLength, :enter, "01234")
    expect(fcall(:countLength, :getValue)).to eql(5)
    fcall(:countLength, :leave, "0123")
    expect(fcall(:countLength, :getValue)).to eql(1)
    fcall(:countLength, :clear)
    expect(fcall(:countLength, :getValue)).to eql(0)
  end
end
