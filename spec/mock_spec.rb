require 'norikra/udf_spec_helper'

include Norikra::UDFSpecHelper

require 'norikra/udf/mock'

describe Norikra::UDF::PassThrough do
  udf_function Norikra::UDF::PassThrough

  it 'returns argument itself' do
    source = "xxx yyy zzz"
    r = call(:passThrough, source)
    expect(r).to eql(source)
  end
end

describe Norikra::UDF::CountLength do
  udf_function Norikra::UDF::CountLength, :valueType => java.lang.Long, :parameters => [[java.lang.String]]

  it 'returns Long' do
    expect(call(:countLength, :getValueType)).to eql(java.lang.Long.java_class)
  end

  it 'counts sum of length of Strings' do
    f = function(:countLength)

    f.call(:enter, ["01234"].to_java(:string))
    f.call(:enter, ["56789"].to_java(:string))
    f.call(:enter, ["01234"].to_java(:string))
    f.call(:enter, ["56789"].to_java(:string))
    expect(f.call(:getValue)).to eql(20)
    f.call(:clear)
    expect(f.call(:getValue)).to eql(0)
  end

  it 'can decrements count with leave' do
    expect(call(:countLength, :getValue)).to eql(0)
    call(:countLength, :enter, ["01234"].to_java(:string))
    expect(call(:countLength, :getValue)).to eql(5)
    call(:countLength, :leave, ["0123"].to_java(:string))
    expect(call(:countLength, :getValue)).to eql(1)
    call(:countLength, :clear)
    expect(call(:countLength, :getValue)).to eql(0)
  end
end
