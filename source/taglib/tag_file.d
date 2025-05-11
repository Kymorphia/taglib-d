module taglib.tag_file;

import std.string : fromStringz, toStringz;

import taglib.tag_c;
import taglib.tag_variant;

alias FileType = TagLib_File_Type; /// File type enum

/// TagFile class
class TagFile
{
  /**
   * Create a TagFile from a filename. The file type will be guessed by TagLib.
   * Params:
   *   filename = The name of the file
   */
  this(string filename)
  {
    taglib_set_string_management_enabled(false);
    _file = taglib_file_new(filename.toStringz);
  }

  /**
   * Create a TagFile from a filename. Rather than trying to guess the type it will use the one specified.
   * Params:
   *   filename = The name of the file
   *   type = The file type to use
   */
  this(string filename, FileType type)
  {
    taglib_set_string_management_enabled(false);
    _file = taglib_file_new_type(filename.toStringz, type);
  }

  /**
   * Create a TagFile object from data in memory.
   * Params:
   *   data = The data to use for the file
   */
  this(ubyte[] data)
  {
    taglib_set_string_management_enabled(false);
    _ioStream = taglib_memory_iostream_new(cast(char*)data.ptr, cast(uint)data.length);
    _file = taglib_file_new_iostream(_ioStream);
  }

  ~this()
  {
    if (_ioStream)
      taglib_iostream_free(_ioStream);

    if (_file)
      taglib_file_free(_file);
  }

  /**
   * Is file open, readable, and valid information for the Tag/AudioProperties was found.
   * Returns: true if valid, false otherwise
   */
  bool isValid()
  {
    return taglib_file_is_valid(_file);
  }

  /**
   * Get title tag.
   * Returns: The title
   */
  @property string title()
  {
    auto cstr = taglib_tag_title(tag);
    scope(exit) taglib_free(cstr);
    return cstr.fromStringz.idup;
  }

  /**
   * Get artist tag.
   * Returns: The artist
   */
  @property string artist()
  {
    auto cstr = taglib_tag_artist(tag);
    scope(exit) taglib_free(cstr);
    return cstr.fromStringz.idup;
  }

  /**
   * Get album tag.
   * Returns: The album
   */
  @property string album()
  {
    auto cstr = taglib_tag_album(tag);
    scope(exit) taglib_free(cstr);
    return cstr.fromStringz.idup;
  }

  /**
   * Get comment tag.
   * Returns: The comment
   */
  @property string comment()
  {
    auto cstr = taglib_tag_comment(tag);
    scope(exit) taglib_free(cstr);
    return cstr.fromStringz.idup;
  }

  /**
   * Get genre tag.
   * Returns: The genre
   */
  @property string genre()
  {
    auto cstr = taglib_tag_genre(tag);
    scope(exit) taglib_free(cstr);
    return cstr.fromStringz.idup;
  }

  /**
   * Get year tag.
   * Returns: The year
   */
  @property uint year()
  {
    return taglib_tag_year(tag);
  }

  /**
   * Get track tag.
   * Returns: The track
   */
  @property uint track()
  {
    return taglib_tag_track(tag);
  }

  /**
   * Get the length of the file in seconds.
   */
  @property int length()
  {
    return taglib_audioproperties_length(audioProps);
  }

  /**
   * Get the bitrate of the file in kb/s.
   */
  @property int bitrate()
  {
    return taglib_audioproperties_bitrate(audioProps);
  }

  /**
   * Get the sample rate of the file in Hz.
   */
  @property int samplerate()
  {
    return taglib_audioproperties_samplerate(audioProps);
  }

  /**
   * Get the number of channels of the file.
   */
  @property int channels()
  {
    return taglib_audioproperties_channels(audioProps);
  }

  /**
   * A convenience method to get all properties and their values.
   * Returns: A map keyed by property name with an array of string values for each property
   */
  string[][string] getPropValues()
  {
    string[][string] propVals;

    foreach(k; getPropKeys)
      propVals[k] = getProp(k);

    return propVals;
  }

  /**
   * Get values for a property.
   * Params:
   *   name = Name of the property
   * Returns: Array of values for the property (can be empty)
   */
  string[] getProp(string name)
  {
    auto cVals = taglib_property_get(_file, name.toStringz);
    string[] vals;

    if (!cVals)
      return vals;

    scope(exit) taglib_property_free(cVals);

    for (auto i = 0; cVals[i]; i++)
      vals ~= cVals[i].fromStringz.idup;

    return vals;
  }

  /**
   * Get property keys for a TagFile.
   * Returns: Array of property keys
   */
  string[] getPropKeys()
  {
    auto cKeys = taglib_property_keys(_file);
    string[] keys;

    if (!cKeys)
      return keys;

    scope(exit) taglib_property_free(cKeys);

    for (auto i = 0; cKeys[i]; i++)
      keys ~= cKeys[i].fromStringz.idup;

    return keys;
  }

  /**
   * A convenience method to get all complex properties and their values.
   * Returns: A map keyed by complex property name with an associative array of property names and TagVariant values
   */
  TagVariant[string][string] getComplexPropValues()
  {
    TagVariant[string][string] propVals;

    foreach(k; getComplexPropKeys)
      propVals[k] = getComplexProp(k);

    return propVals;
  }

  /**
   * Get a complex property value.
   * Params:
   *   name = Name of property to get
   * Returns: Complex property map of key names to TagVariant values
   */
  TagVariant[string] getComplexProp(string name)
  {
    TagLib_Complex_Property_Attribute*** maps = taglib_complex_property_get(_file, name.toStringz);
    TagVariant[string] propValues;

    if (!maps)
      return propValues;

    scope(exit) taglib_complex_property_free(maps);

    for (auto i = 0; maps[i]; i++)
    {
      auto attribs = maps[i];

      for (auto i2 = 0; attribs[i2]; i2++)
      {
        auto attr = attribs[i2];
        auto keyName = attr.key.fromStringz.idup;
        propValues[keyName] = TagVariant(attr.value);
      }
    }

    return propValues;
  }

  /**
   * Get complex property keys for a TagFile.
   * Returns: Array of complex property keys
   */
  @property string[] getComplexPropKeys()
  {
    auto cKeys = taglib_complex_property_keys(_file);
    string[] keys;

    if (!cKeys)
      return keys;

    scope(exit) taglib_complex_property_free_keys(cKeys);

    for (auto i = 0; cKeys[i]; i++)
      keys ~= cKeys[i].fromStringz.idup;

    return keys;
  }

  /**
   * Set title tag.
   * Params:
   *   val = The title
   */
  @property void title(string val)
  {
    taglib_tag_set_title(tag, val.toStringz);
  }

  /**
   * Set artist tag.
   * Params:
   *   val = The artist
   */
  @property void artist(string val)
  {
    taglib_tag_set_artist(tag, val.toStringz);
  }

  /**
   * Set album tag.
   * Params:
   *   val = The album
   */
  @property void album(string val)
  {
    taglib_tag_set_album(tag, val.toStringz);
  }

  /**
   * Set comment tag.
   * Params:
   *   val = The comment
   */
  @property void comment(string val)
  {
    taglib_tag_set_comment(tag, val.toStringz);
  }

  /**
   * Set genre tag.
   * Params:
   *   val = The genre
   */
  @property void genre(string val)
  {
    taglib_tag_set_genre(tag, val.toStringz);
  }

  /**
   * Set year tag.
   * Params:
   *   val = The year
   */
  @property void year(uint val)
  {
    taglib_tag_set_year(tag, val);
  }

  /**
   * Set track tag.
   * Params:
   *   val = The track
   */
  @property void track(uint val)
  {
    taglib_tag_set_track(tag, val);
  }

  /**
   * Set a property or clear it.
   * Params:
   *   name = Name of property
   *   value = Value of property (null to clear it)
   */
  void setProp(string name, string value)
  {
    taglib_property_set(_file, name.toStringz, value.toStringz);
  }

  /**
   * Append a value to a property or clear it.
   * Params:
   *   name = Name of property
   *   value = Value to append to property (null to clear it)
   */
  void appendProp(string name, string value)
  {
    taglib_property_set_append(_file, name.toStringz, value.toStringz);
  }

  /**
   * Set complex properties.
   * Params:
   *   name = Key name of complex property to assign
   *   values = Associative array of string keys and TagVariant structure values or null to clear
   * Returns: true on success, false otherwise
   */
  bool setComplexProp(string name, TagVariant[string] values)
  {
    if (values.length == 0)
    {
      taglib_complex_property_set(_file, name.toStringz, null);
      return true;
    }

    TagLib_Complex_Property_Attribute*[] attribs;

    foreach (key, val; values)
    {
      attribs ~= new TagLib_Complex_Property_Attribute;
      attribs[$ - 1].key = cast(char*)key.toStringz;
      attribs[$ - 1].value = val.cVariant;
    }

    attribs ~= null; // null termination

    return taglib_complex_property_set(_file, name.toStringz, attribs.ptr);
  }

  /**
   * Append complex property values.
   * Params:
   *   name = Key name of complex property to append to
   *   values = Associative array of string keys and TagVariant structure values to append or null to clear
   * Returns: true on success, false otherwise
   */
  bool appendComplexProp(string name, TagVariant[string] values)
  {
    if (values.length == 0)
    {
      taglib_complex_property_set_append(_file, name.toStringz, null);
      return true;
    }

    TagLib_Complex_Property_Attribute*[] attribs;

    foreach (key, val; values)
    {
      attribs ~= new TagLib_Complex_Property_Attribute;
      attribs[$ - 1].key = cast(char*)key.toStringz;
      attribs[$ - 1].value = val.cVariant;
    }

    attribs ~= null; // null termination

    return taglib_complex_property_set_append(_file, name.toStringz, attribs.ptr);
  }

  /**
   * Saves the file to disk.
   * Returns: true on success, false otherwise
   */
  bool save()
  {
    return taglib_file_save(_file);
  }

  /**
   * Get the Tag associated with a File object.
   *
   * NOTE: Most users will not need to use this, since there are other more convenient individual properties.
   *
   * Returns: The Tag
   */
  @property TagLib_Tag* tag()
  {
    if (!_tag)
      _tag = taglib_file_tag(_file); // Gets freed when _file does

    return _tag;
  }

  /**
   * Get audio properties structure for a file.
   *
   * NOTE: Most users will not need to use this, since there are other more convenient individual properties.
   *
   * Returns: Audio properties structure pointer
   */
  @property const(TagLib_AudioProperties)* audioProps()
  {
    if (!_audioProps)
      _audioProps = taglib_file_audioproperties(_file); // Gets freed when _file does

    return _audioProps;
  }

private:
  TagLib_File* _file;
  TagLib_IOStream* _ioStream;
  TagLib_Tag *_tag;
  const(TagLib_AudioProperties)* _audioProps;
}
