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

# describe Norikra::UDF::CountLength do
#   udf_function Norikra::UDF::CountLength, :valueType => java.lang.Long, :parameters => [[java.lang.String]]

#   it 'returns Long' do
#     expect(fcall(:countLength, :getValueType)).to eql(java.lang.Long.java_class)
#   end

#   it 'counts sum of length of Strings' do
#     f = function(:countLength)

#     f._call(:enter, "01234")
#     f._call(:enter, "56789")
#     f._call(:enter, "01234")
#     f._call(:enter, "56789")
#     v = f.getValue
#     expect(v).to eql(20)
#     f._call(:clear)
#     expect(f._call(:getValue)).to eql(0)
#   end

#   it 'can decrements count with leave' do
#     expect(fcall(:countLength, :getValue)).to eql(0)
#     fcall(:countLength, :enter, "01234")
#     expect(fcall(:countLength, :getValue)).to eql(5)
#     fcall(:countLength, :leave, "0123")
#     expect(fcall(:countLength, :getValue)).to eql(1)
#     fcall(:countLength, :clear)
#     expect(fcall(:countLength, :getValue)).to eql(0)
#   end
# end

