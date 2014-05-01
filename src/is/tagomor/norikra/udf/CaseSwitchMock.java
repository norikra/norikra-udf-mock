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

  public static String concatSnakeCased(final String... args)
  {
    StringBuffer buf = new StringBuffer();
    for (String s: args) {
      if (buf.length() > 0)
        buf.append("_");
      buf.append(s);
    }
    return buf.toString();
  }
}
