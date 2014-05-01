package is.tagomor.norikra.udf;

public final class CaseSwitchMock
{
  public static String upcase(final String source)
  {
    return source.toUpperCase();
  }

  public static String downcase(final String source)
  {
    return source.toLowerCase();
  }
}
