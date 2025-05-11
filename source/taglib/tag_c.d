module taglib.tag_c;

/*
 * This file was ported to D from TagLib v2.0.2.
 * Ported by: Element Green <element@kymorphia.com>
 * 2025-05-10
 */

/*
    copyright            : (C) 2003 by Scott Wheeler
    email                : wheeler@kde.org
 */

/*
 *   This library is free software; you can redistribute it and/or modify  *
 *   it  under the terms of the GNU Lesser General Public License version  *
 *   2.1 as published by the Free Software Foundation.                     *
 *                                                                         *
 *   This library is distributed in the hope that it will be useful, but   *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   Lesser General Public License for more details.                       *
 *                                                                         *
 *   You should have received a copy of the GNU Lesser General Public      *
 *   License along with this library; if not, write to the Free Software   *
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  *
 *   USA                                                                   *
 */

/*
 * [ TagLib C Binding ]
 *
 * This is an interface to TagLib's "simple" API, meaning that you can read and
 * modify media files in a generic, but not specialized way.  This is a rough
 * representation of TagLib::File and TagLib::Tag, for which the documentation
 * is somewhat more complete and worth consulting.
 */

/*
 * These are used to give the C API some type safety (as opposed to
 * using void * ), but pointers to them are simply cast to the corresponding C++
 * types in the implementation.
 */

struct TagLib_File { int dummy; }
struct TagLib_Tag { int dummy; }
struct TagLib_AudioProperties { int dummy; }
struct TagLib_IOStream { int dummy; }

/**
 * By default all strings coming into or out of TagLib's C API are in UTF8.
 * However, it may be desirable for TagLib to operate on Latin1 (ISO-8859-1)
 * strings in which case this should be set to false.
 */
extern(C) void taglib_set_strings_unicode(bool unicode);

/**
 * TagLib can keep track of strings that are created when outputting tag values
 * and clear them using taglib_tag_clear_strings().  This is enabled by default.
 * However if you wish to do more fine grained management of strings, you can do
 * so by setting management to false.
 */
extern(C) void taglib_set_string_management_enabled(bool management);

/**
 * Explicitly free a string returned from TagLib
 */
extern(C) void taglib_free(void* pointer);

/*
 * Stream API
 */

/**
 * Creates a byte vector stream from size bytes of data.
 * Such a stream can be used with taglib_file_new_iostream() to create a file
 * from memory.
 */
extern(C) TagLib_IOStream* taglib_memory_iostream_new(const(char)* data, uint size);

/**
 * Frees and closes the stream.
 */
extern(C) void taglib_iostream_free(TagLib_IOStream* stream);

/*
 * File API
 */

/// File type
enum TagLib_File_Type
{
  MPEG,
  OggVorbis,
  FLAC,
  MPC,
  OggFlac,
  WavPack,
  Speex,
  TrueAudio,
  MP4,
  ASF,
  AIFF,
  WAV,
  APE,
  IT,
  Mod,
  S3M,
  XM,
  Opus,
  DSF,
  DSDIFF,
  SHORTEN
}

/**
 * Creates a TagLib file based on filename.  TagLib will try to guess the file
 * type.
 *
 * Returns: null if the file type cannot be determined or the file cannot
 * be opened.
 */
extern(C) TagLib_File* taglib_file_new(const(char)* filename);

/**
 * Creates a TagLib file based on filename.  Rather than attempting to guess
 * the type, it will use the one specified by type.
 */
extern(C) TagLib_File* taglib_file_new_type(const(char)* filename, TagLib_File_Type type);

/**
 * Creates a TagLib file from a stream.
 * A byte vector stream can be used to read a file from memory and write to
 * memory, e.g. when fetching network data.
 * The stream has to be created using taglib_memory_iostream_new() and shall be
 * freed using taglib_iostream_free() after this file is freed with
 * taglib_file_free().
 */
extern(C) TagLib_File* taglib_file_new_iostream(TagLib_IOStream* stream);

/**
 * Frees and closes the file.
 */
extern(C) void taglib_file_free(TagLib_File* file);

/**
 * Returns true if the file is open and readable and valid information for
 * the Tag and / or AudioProperties was found.
 */

extern(C) bool taglib_file_is_valid(const(TagLib_File)* file);

/**
 * Returns a pointer to the tag associated with this file.  This will be freed
 * automatically when the file is freed.
 */
extern(C) TagLib_Tag* taglib_file_tag(const(TagLib_File)* file);

/**
 * Returns a pointer to the audio properties associated with this file.  This
 * will be freed automatically when the file is freed.
 */
extern(C) const(TagLib_AudioProperties)* taglib_file_audioproperties(const(TagLib_File)* file);

/**
 * Saves the file to disk.
 */
extern(C) bool taglib_file_save(TagLib_File* file);

/******************************************************************************
 * Tag API
 ******************************************************************************/

/**
 * Returns a string with this tag's title.
 *
 * By default this string should be UTF8 encoded and its memory should be
 * freed using taglib_tag_free_strings().
 */
extern(C) char* taglib_tag_title(const(TagLib_Tag)* tag);

/**
 * Returns a string with this tag's artist.
 *
 * By default this string should be UTF8 encoded and its memory should be
 * freed using taglib_tag_free_strings().
 */
extern(C) char* taglib_tag_artist(const(TagLib_Tag)* tag);

/**
 * Returns a string with this tag's album name.
 *
 * By default this string should be UTF8 encoded and its memory should be
 * freed using taglib_tag_free_strings().
 */
extern(C) char* taglib_tag_album(const(TagLib_Tag)* tag);

/**
 * Returns a string with this tag's comment.
 *
 * By default this string should be UTF8 encoded and its memory should be
 * freed using taglib_tag_free_strings().
 */
extern(C) char* taglib_tag_comment(const(TagLib_Tag)* tag);

/**
 * Returns a string with this tag's genre.
 *
 * By default this string should be UTF8 encoded and its memory should be
 * freed using taglib_tag_free_strings().
 */
extern(C) char* taglib_tag_genre(const(TagLib_Tag)* tag);

/**
 * Returns the tag's year or 0 if the year is not set.
 */
extern(C) uint taglib_tag_year(const(TagLib_Tag)* tag);

/**
 * Returns the tag's track number or 0 if the track number is not set.
 */
extern(C) uint taglib_tag_track(const(TagLib_Tag)* tag);

/**
 * Sets the tag's title.
 *
 * By default this string should be UTF8 encoded.
 */
extern(C) void taglib_tag_set_title(TagLib_Tag* tag, const(char)* title);

/**
 * Sets the tag's artist.
 *
 * By default this string should be UTF8 encoded.
 */
extern(C) void taglib_tag_set_artist(TagLib_Tag* tag, const(char)* artist);

/**
 * Sets the tag's album.
 *
 * By default this string should be UTF8 encoded.
 */
extern(C) void taglib_tag_set_album(TagLib_Tag *tag, const(char)* album);

/**
 * Sets the tag's comment.
 *
 * By default this string should be UTF8 encoded.
 */
extern(C) void taglib_tag_set_comment(TagLib_Tag* tag, const(char)* comment);

/**
 * Sets the tag's genre.
 *
 * By default this string should be UTF8 encoded.
 */
extern(C) void taglib_tag_set_genre(TagLib_Tag* tag, const(char)* genre);

/**
 * Sets the tag's year.  0 indicates that this field should be cleared.
 */
extern(C) void taglib_tag_set_year(TagLib_Tag* tag, uint year);

/**
 * Sets the tag's track number.  0 indicates that this field should be cleared.
 */
extern(C) void taglib_tag_set_track(TagLib_Tag* tag, uint track);

/**
 * Frees all of the strings that have been created by the tag.
 */
extern(C) void taglib_tag_free_strings();

/******************************************************************************
 * Audio Properties API
 ******************************************************************************/

/**
 * Returns the length of the file in seconds.
 */
extern(C) int taglib_audioproperties_length(const(TagLib_AudioProperties)* audioProperties);

/**
 * Returns the bitrate of the file in kb/s.
 */
extern(C) int taglib_audioproperties_bitrate(const(TagLib_AudioProperties)* audioProperties);

/**
 * Returns the sample rate of the file in Hz.
 */
extern(C) int taglib_audioproperties_samplerate(const(TagLib_AudioProperties)* audioProperties);

/**
 * Returns the number of channels in the audio stream.
 */
extern(C) int taglib_audioproperties_channels(const(TagLib_AudioProperties)* audioProperties);

/*******************************************************************************
 * Special convenience ID3v2 functions
 *******************************************************************************/

enum TagLib_ID3v2_Encoding
{
  Latin1,
  UTF16,
  UTF16BE,
  UTF8
}

/**
 * This sets the default encoding for ID3v2 frames that are written to tags.
 */
extern(C) void taglib_id3v2_set_default_text_encoding(TagLib_ID3v2_Encoding encoding);

/******************************************************************************
 * Properties API
 ******************************************************************************/

/**
 * Sets the property prop with value.  Use value = null to remove
 * the property, otherwise it will be replaced.
 */
extern(C) void taglib_property_set(TagLib_File* file, const(char)* prop, const(char)* value);

/**
 * Appends value to the property prop (sets it if non-existing).
 * Use value = null to remove all values associated with the property.
 */
extern(C) void taglib_property_set_append(TagLib_File* file, const(char)* prop, const(char)* value);

/**
 * Get the keys of the property map.
 *
 * Return: null terminated array of C-strings (char *), only null if empty.
 * It must be freed by the client using taglib_property_free().
 */
extern(C) char** taglib_property_keys(const(TagLib_File)* file);

/**
 * Get value(s) of property prop.
 *
 * Return: null terminated array of C-strings (char *), only null if empty.
 * It must be freed by the client using taglib_property_free().
 */
extern(C) char** taglib_property_get(const(TagLib_File)* file, const(char)* prop);

/**
 * Frees the null terminated array props and the C-strings it contains.
 */
extern(C) void taglib_property_free(char** props);

/******************************************************************************
 * Complex Properties API
 ******************************************************************************/

/**
 * Types which can be stored in a TagLib_Variant.
 *
 * These correspond to TagLib::Variant::Type, but ByteVectorList, VariantList,
 * VariantMap are not supported and will be returned as their string
 * representation.
 */
enum TagLib_Variant_Type
{
  Void,
  Bool,
  Int,
  UInt,
  LongLong,
  ULongLong,
  Double,
  String,
  StringList,
  ByteVector
}

/**
 * Discriminated union used in complex property attributes.
 *
 * type must be set according to the value union used.
 * size is only required for TagLib_Variant.ByteVector and must contain
 * the number of bytes.
 */
struct TagLib_Variant
{
  TagLib_Variant_Type type;
  uint size;

  union
  {
    char* stringValue;
    char* byteVectorValue;
    char** stringListValue;
    bool boolValue;
    int intValue;
    uint uIntValue;
    long longLongValue;
    ulong uLongLongValue;
    double doubleValue;
  }
}

/**
 * Attribute of a complex property.
 * Complex properties consist of a null-terminated array of pointers to
 * this structure with key and value.
 */
struct TagLib_Complex_Property_Attribute
{
  char* key;
  TagLib_Variant value;
}

/**
 * Picture data extracted from a complex property by the convenience function
 * taglib_picture_from_complex_property().
 */
struct TagLib_Complex_Property_Picture_Data
{
  char* mimeType;
  char* description;
  char* pictureType;
  char* data;
  uint size;
}

/**
 * Declare complex property attributes to set a picture.
 * Can be used to define a variable var which can be used with
 * taglib_complex_property_set() and a "PICTURE" key to set an
 * embedded picture with the picture data dat of size siz
 * and description desc, mime type mime and picture type
 * typ (size is unsigned int, the other input parameters char *).
 */
/*
#define TAGLIB_COMPLEX_PROPERTY_PICTURE(var, dat, siz, desc, mime, typ)   \
const TagLib_Complex_Property_Attribute            \
var##Attrs[] = {                                   \
  {                                                \
    (char *)"data",                                \
    {                                              \
      TagLib_Variant_ByteVector,                   \
      (siz),                                       \
      {                                            \
        (char *)(dat)                              \
      }                                            \
    }                                              \
  },                                               \
  {                                                \
    (char *)"mimeType",                            \
    {                                              \
      TagLib_Variant_String,                       \
      0U,                                          \
      {                                            \
        (char *)(mime)                             \
      }                                            \
    }                                              \
  },                                               \
  {                                                \
    (char *)"description",                         \
    {                                              \
      TagLib_Variant_String,                       \
      0U,                                          \
      {                                            \
        (char *)(desc)                             \
      }                                            \
    }                                              \
  },                                               \
  {                                                \
    (char *)"pictureType",                         \
    {                                              \
      TagLib_Variant_String,                       \
      0U,                                          \
      {                                            \
        (char *)(typ)                              \
      }                                            \
    }                                              \
  }                                                \
};                                                 \
const TagLib_Complex_Property_Attribute *var[] = { \
  &var##Attrs[0], &var##Attrs[1], &var##Attrs[2],  \
  &var##Attrs[3], null                             \
}
*/

/**
 * Sets the complex property key with value.  Use value = null to
 * remove the property, otherwise it will be replaced with the null
 * terminated array of attributes in value.
 *
 * A picture can be set with the TAGLIB_COMPLEX_PROPERTY_PICTURE macro:
 *
 * \code {.c}
 * TagLib_File* file = taglib_file_new("myfile.mp3");
 * FILE *fh = fopen("mypicture.jpg", "rb");
 * if(fh) {
 *   fseek(fh, 0L, SEEK_END);
 *   long size = ftell(fh);
 *   fseek(fh, 0L, SEEK_SET);
 *   char *data = (char *)malloc(size);
 *   fread(data, size, 1, fh);
 *   TAGLIB_COMPLEX_PROPERTY_PICTURE(props, data, size, "Written by TagLib",
 *                                   "image/jpeg", "Front Cover");
 *   taglib_complex_property_set(file, "PICTURE", props);
 *   taglib_file_save(file);
 *   free(data);
 *   fclose(fh);
 * }
 * \endcode
 */
extern(C) bool taglib_complex_property_set(
  TagLib_File* file, const(char)* key,
  const(TagLib_Complex_Property_Attribute**) value);

/**
 * Appends value to the complex property key (sets it if non-existing).
 * Use value = null to remove all values associated with the key.
 */
extern(C) bool taglib_complex_property_set_append(
  TagLib_File* file, const(char)* key,
  const(TagLib_Complex_Property_Attribute**) value);

/**
 * Get the keys of the complex properties.
 *
 * Return: null terminated array of C-strings (char *), only null if empty.
 * It must be freed by the client using taglib_complex_property_free_keys().
 */
extern(C) char** taglib_complex_property_keys(const(TagLib_File)* file);

/**
 * Get value(s) of complex property key.
 *
 * Return: null terminated array of property values, which are themselves an
 * array of property attributes, only null if empty.
 * It must be freed by the client using taglib_complex_property_free().
 */
extern(C) TagLib_Complex_Property_Attribute*** taglib_complex_property_get(
  const(TagLib_File)* file, const(char)* key);

/**
 * Extract the complex property values of a picture.
 *
 * This function can be used to get the data from a "PICTURE" complex property
 * without having to traverse the whole variant map. A picture can be
 * retrieved like this:
 *
 * \code {.c}
 * TagLib_File* file = taglib_file_new("myfile.mp3");
 * TagLib_Complex_Property_Attribute*** properties =
 *   taglib_complex_property_get(file, "PICTURE");
 * TagLib_Complex_Property_Picture_Data picture;
 * taglib_picture_from_complex_property(properties, &picture);
 * // Do something with picture.mimeType, picture.description,
 * // picture.pictureType, picture.data, picture.size, e.g. extract it.
 * FILE *fh = fopen("mypicture.jpg", "wb");
 * if(fh) {
 *   fwrite(picture.data, picture.size, 1, fh);
 *   fclose(fh);
 * }
 * taglib_complex_property_free(properties);
 * \endcode
 *
 * Note that the data in picture contains pointers to data in properties,
 * i.e. it only lives as long as the properties, until they are freed with
 * taglib_complex_property_free().
 * If you want to access multiple pictures or additional properties of FLAC
 * pictures ("width", "height", "numColors", "colorDepth" int values), you
 * have to traverse the properties yourself.
 */
extern(C) void taglib_picture_from_complex_property(
  TagLib_Complex_Property_Attribute*** properties,
  TagLib_Complex_Property_Picture_Data* picture);

/**
 * Frees the null terminated array keys (as returned by
 * taglib_complex_property_keys()) and the C-strings it contains.
 */
extern(C) void taglib_complex_property_free_keys(char** keys);

/**
 * Frees the null terminated array props of property attribute arrays
 * (as returned by taglib_complex_property_get()) and the data such as
 * C-strings and byte vectors contained in these attributes.
 */
extern(C) void taglib_complex_property_free(
  TagLib_Complex_Property_Attribute*** props);
