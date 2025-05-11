module taglib.tag_variant;

import std.conv : ConvException, to;
import std.exception : enforce;
import std.string : fromStringz, toStringz;

import taglib.tag_c;

alias VariantType = TagLib_Variant_Type; /// Variant type enum alias

/// Structure to wrap a TagLib_Variant
struct TagVariant
{
  /**
   * Create a TagVariant from a D value using a template constructor.
   * Params:
   *   T = The value type
   *   val = The value to assign to the new TagVariant structure
   */
  this(T)(T val)
    if(!is(T == TagLib_Variant*))
  {
    set(val);
  }

  /**
   * Create a TagVariant from a C TagLib_Variant.
   * Params:
   *   variant = The TagLib_Variant from C code
   */
  this(ref const(TagLib_Variant) variant)
  {
    switch (variant.type) with (VariantType)
    {
      case Bool:
        set(getVariant!bool(variant));
        break;
      case Int:
        set(getVariant!int(variant));
        break;
      case UInt:
        set(getVariant!uint(variant));
        break;
      case LongLong:
        set(getVariant!long(variant));
        break;
      case ULongLong:
        set(getVariant!ulong(variant));
        break;
      case Double:
        set(getVariant!double(variant));
        break;
      case String:
        set(getVariant!string(variant));
        break;
      case StringList:
        set(getVariant!(string[])(variant));
        break;
      case ByteVector:
        set(getVariant!(byte[])(variant));
        break;
      default: // Void or unknown
        break;
    }
  }

  ///
  string toString() const
  {
    switch (cVariant.type) with (VariantType)
    {
      case Bool:
        return get!bool.to!string;
      case Int:
        return get!int.to!string;
      case UInt:
        return get!uint.to!string;
      case LongLong:
        return get!long.to!string;
      case ULongLong:
        return get!ulong.to!string;
      case Double:
        return get!double.to!string;
      case String:
        return get!string;
      case StringList:
        return get!(string[]).to!string;
      case ByteVector:
        return "<ByteVector>";
      default: // Void or unknown
        return "<Void>";
    }
  }

  /**
   * Convenience method to get the type stored in cVariant.
   * Returns: The current type enum
   */
  @property VariantType type()
  {
    return cVariant.type;
  }

  /**
   * Template to get a TagVariant value using a D type.
   * Params:
   *   T = The value type
   * Returns: The value
   * Throws: ConvException, ConvOverflowException
   */
  T get(T)() const
  {
    return getVariant!T(cVariant);
  }

  /**
   * Template to set a TagVariant value using a D type.
   * Params:
   *   T = The value type
   *   val = The value to assign to the TagLib_Variant value
   */
  void set(T)(T val)
  {
    setVariant(cVariant, val);
  }

  /// Convenience method to get a bool from a TagVariant
  bool getBool()
  {
    return get!bool;
  }

  /// Convenience method to get an int from a TagVariant
  int getInt()
  {
    return get!int;
  }

  /// Convenience method to get an uint from a TagVariant
  uint getUInt()
  {
    return get!uint;
  }

  /// Convenience method to get a long from a TagVariant
  long getLong()
  {
    return get!long;
  }

  /// Convenience method to get a ulong from a TagVariant
  ulong getULong()
  {
    return get!ulong;
  }

  /// Convenience method to get a double from a TagVariant
  double getDouble()
  {
    return get!double;
  }

  /// Convenience method to get a string from a TagVariant
  string getString()
  {
    return get!string;
  }

  /// Convenience method to get a string list from a TagVariant
  string[] getStringList()
  {
    return get!(string[]);
  }

  /// Convenience method to get a byte array from a TagVariant
  byte[] getByteArray()
  {
    return get!(byte[]);
  }

  TagLib_Variant cVariant;
}

/**
 * Template to get a TagVariant value using a D type.
 * Params:
 *   T = The value type
 *   variant = The TagLib_Variant structure pointer
 * Returns: The value
 * Throws: ConvException, ConvOverflowException
 */
T getVariant(T)(ref const(TagLib_Variant) variant)
{
  static if (is(T == bool))
  {
    enforce!ConvException(variant.type == VariantType.Bool, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.boolValue;
  }
  else static if (is(T == int))
  {
    enforce!ConvException(variant.type == VariantType.Int, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.intValue;
  }
  else static if (is(T == uint))
  {
    enforce!ConvException(variant.type == VariantType.UInt, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.uIntValue;
  }
  else static if (is(T == long))
  {
    enforce!ConvException(variant.type == VariantType.LongLong, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.longLongValue;
  }
  else static if (is(T == ulong))
  {
    enforce!ConvException(variant.type == VariantType.ULongLong, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.uLongLongValue;
  }
  else static if (is(T == double))
  {
    enforce!ConvException(variant.type == VariantType.Double, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.doubleValue;
  }
  else static if (is(T == string))
  {
    enforce!ConvException(variant.type == VariantType.String, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return variant.stringValue.fromStringz.idup;
  }
  else static if (is(T == string[]))
  {
    enforce!ConvException(variant.type == VariantType.StringList, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    string[] strList;

    for (auto i = 0; variant.stringListValue[i]; i++)
      strList ~= variant.stringListValue[i].fromStringz.idup;

    return strList;
  }
  else static if (is(T == byte[]))
  {
    enforce!ConvException(variant.type == VariantType.ByteVector, "getVariant: " ~ T.stringof
      ~ " cannot be used to get VariantType." ~ variant.type.to!string);
    return (cast(byte*)variant.byteVectorValue)[0 .. variant.size].dup;
  }
  else
    assert(0, "Unsupported type " ~ T.stringof ~ " in Value.set");    
}

/**
 * Template to set a TagVariant value using a D type.
 * Params:
 *   T = The value type
 *   variant = The TagLib_Variant structure pointer
 *   val = The value to assign to the TagLib_Variant value
 */
void setVariant(T)(ref TagLib_Variant variant, T val)
{
  static if (is(T == bool))
  {
    variant.type = VariantType.Bool;
    variant.boolValue = val;
  }
  else static if (is(T == int))
  {
    variant.type = VariantType.Int;
    variant.intValue = val;
  }
  else static if (is(T == uint))
  {
    variant.type = VariantType.UInt;
    variant.uIntValue = val;
  }
  else static if (is(T == long))
  {
    variant.type = VariantType.LongLong;
    variant.longLongValue = val;
  }
  else static if (is(T == ulong))
  {
    variant.type = VariantType.ULongLong;
    variant.uLongLongValue = val;
  }
  else static if (is(T == double))
  {
    variant.type = VariantType.Double;
    variant.doubleValue = val;
  }
  else static if (is(T == string))
  {
    variant.type = VariantType.String;
    variant.stringValue = cast(char*)val.toStringz;
  }
  else static if (is(T == string[]))
  {
    auto strList = new char*[](val.length);

    foreach (i, s; val)
      strList[i] = cast(char*)s.toStringz;

    variant.type = VariantType.StringList;
    variant.stringListValue = strList.ptr;
  }
  else static if (is(T == byte[]))
  {
    variant.type = VariantType.ByteVector;
    variant.size = cast(uint)val.length;
    variant.byteVectorValue = cast(char*)val.ptr;
  }
  else
    assert(0, "Unsupported type " ~ T.stringof ~ " in setVariant");    
}
