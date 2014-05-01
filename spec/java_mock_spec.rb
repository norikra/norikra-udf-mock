# -*- coding: utf-8 -*-
require 'norikra/udf_spec_helper'

include Norikra::UDFSpecHelper

require 'norikra/udf/mock'

describe Norikra::UDF::Upcase do
  udf_function Norikra::UDF::Upcase

  it 'returns upcase string' do
    source = "Tagomori Satoshi"
    r = fcall(:upcase, source)
    expect(r).to eql(source.upcase)
  end
end

describe Norikra::UDF::Downcase do
  udf_function Norikra::UDF::Downcase

  it 'returns downcase string' do
    source = "Tagomori Satoshi"
    r = fcall(:downcase, source)
    expect(r).to eql(source.downcase)
  end
end

describe Norikra::UDF::Snakecase do
  udf_function Norikra::UDF::Snakecase

  it 'returns snake case string of arguments' do
    r = fcall(:snakecase, "foo", "bar", "baz")
    expect(r).to eql("foo_bar_baz")
  end
end

describe Norikra::UDF::CountBytes do
  udf_function Norikra::UDF::CountBytes, :valueType => java.lang.Long, :parameters => [[java.lang.String]]

  it 'returns Long' do
    expect(fcall(:countBytes, :getValueType)).to eql(java.lang.Long.java_class)
  end

  it 'counts sum of bytes of Strings' do
    f = function(:countBytes)

    f._call(:enter, "abcde")
    f._call(:enter, "あいうえお")
    f._call(:enter, "fghij")
    v = f.getValue

    expect(v).to eql(25) # 5 + 3x5 + 5

    f._call(:clear)

    expect(f._call(:getValue)).to eql(0)
  end

  it 'can decrements count with leave' do
    fcall(:countBytes, :clear)
    expect(fcall(:countBytes, :getValue)).to eql(0)

    fcall(:countBytes, :enter, "01234")
    expect(fcall(:countBytes, :getValue)).to eql(5)

    fcall(:countBytes, :enter, "a")
    expect(fcall(:countBytes, :getValue)).to eql(6)

    fcall(:countBytes, :leave, "01234")
    expect(fcall(:countBytes, :getValue)).to eql(1)

    fcall(:countBytes, :enter, "あいうえお")
    expect(fcall(:countBytes, :getValue)).to eql(16) # 1 + 3x5

    fcall(:countBytes, :leave, "a")
    fcall(:countBytes, :leave, "あいうえお")
    expect(fcall(:countBytes, :getValue)).to eql(0)
  end
end
