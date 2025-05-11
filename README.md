# TagLib D binding

**taglib-d** is a [D language](https://www.dlang.org) binding to the popular [TagLib Audio Meta-Data Library](https://taglib.org/).
This project uses the "simple" C API which is a general purpose interface to all TagLib supported file types.

## Version

Currently taglib-d works with TagLib version 2.x (2.0.2 as of this writing).
This is a relatively new major version and is available on more recent releases of Linux distributions such as Ubuntu 25.04.

The version of taglib-d will match major versions of the TagLib library,
but the minor and micro versions will have no relation between the projects.

## API Documentation

The generated [API Reference Documentation](https://www.kymorphia.com/taglib-d) provides complete documentation on the D and C APIs.
What follows is an overview and some code examples which can be used to get started quickly on developing with TagLib.

## Modules

* [taglib](https://www.kymorphia.com/taglib-d/) is the main top-level package module which includes the other relevant modules.
* `taglib.tag_file` contains the [TagFile](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.html)
  class that is used for interfacing with files and their metadata tags.
* `taglib.tag_variant` implements the [TagVariant](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.html)
  structure which wraps the underlying C variant type used for different tag value types.
* [taglib.tag_c](https://www.kymorphia.com/taglib-d/taglib.tag_c.html) is the raw C API which the D object-oriented API is built on.
  This is not imported in the main `taglib` module and likely wont be used by most users,
  as the D API offers all functionality but with a more convenient native D API.

## TagFile

There are 3 ways to create a [TagFile](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.html) object.

* From a [filename](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.this.1.html) where TagLib tries to guess the file type.
* Using a [filename and type](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.this.2.html) to specify what the file type is.
* From a [buffer in memory](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.this.3.html).

### Basic Properties

Once a TagFile has been created and references a valid supported media file with tags,
[isValid](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.isValid.html) is true,
there are a number of D properties which can be read.

This includes media tags such as:
[title](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.title.1.html),
[artist](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.artist.1.html),
[album](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.album.1.html),
[comment](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.comment.1.html),
[genre](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.genre.1.html),
[year](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.year.1.html), and
[track](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.track.1.html).

These properties also have corresponding setters for assigning values for saving tags.

Additionally there are these read-only audio properties:
[length](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.length.html),
[bitrate](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.bitrate.html),
[samplerate](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.samplerate.html),
and [channels](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.channels.html).

### Named Properties

TagLib also provides a general purpose API to access properties as text key/value pairs.
This includes the [Basic Properties](#basic-properties) as described in the previous section,
as well as additional defined properties, or even custom properties.
These are provided through the following API methods:

* [TagFile.getPropValues](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getPropValues.html)
  returns an associative array of all text properties offered in a file format independent way.
  Keys are uppercase and can have underscores. All map values are dynamic arrays of unicode strings.
  Most values consist of a single string value, but the API makes it possible to have multiple values.
* [TagFile.getProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getProp.html)
  can be used to get the value of a single known property by its key.
  Property values are dynamic arrays of strings, usually just one string value.
* [TagFile.getPropKeys](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getPropKeys.html) 
  returns a list of all the property keys defined for the TagFile.

For setting named properties the following methods can be used:

* [TagFile.setProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.setProp.html)
  can be used to set a single value of a property or clear it (if null is passed as the value).
* [TagFile.appendProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.appendProp.html)
  appends a value to the existing values of a named property or clears it (if null is passed as the value).

For more information on key names for named properties, please consult the
[TagLib::PropertyMap Class C++ Reference](https://taglib.org/api/classTagLib_1_1PropertyMap.html).

### Complex Properties

In addition to [Basic Properties](#basic-properties) and [Named Properties](#named-properties),
TagLib also offers an interface for properties with more complex value types.

Complex properties use the [TagVariant](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.html)
structure to store different values types, described in more detail in the next section.

These are the methods which can be used for getting complex properties:

* [TagFile.getComplexPropValues](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getComplexPropValues.html)
  can be used to get all complex properties. It returns an associative array,
  with the key being the complex property name and the value being another associative array of key/value pairs.
  The values are stored as TagVariant to utilize different value types.
* [TagFile.getComplexProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getComplexProp.html)
  can be used to get a single complex property value, which is returned as an associative array of key/value pairs,
  with the key being the complex property name, and the value being a TagVariant.
* [TagFile.getComplexPropKeys](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.getComplexPropKeys.html)
  returns a dynamic array of all the complex property key names which have values in the TagFile.

The related setter methods for complex properties are described below:

* [TagFile.setComplexProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.setComplexProp.html)
  can be used to set all the name/value pairs of a single complex property.
* [TagFile.appendComplexProp](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.appendComplexProp.html)
  is for adding name/value pairs to existing values for a complex property.

#### TagVariant

taglib-d uses the [TagVariant](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.html) structure
to provide a container for storing complex property values. Supported types include:
bool, int, uint, long, ulong, double, string, string[], and byte[].

`TagVariant` methods and templates:

* A TagVariant can be constructed from a supported D value, using the
  [constructor template](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.this.1.html).
* It can also be constructed using a C [TagLib_Variant](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.this.2.html)
  type, but this is mostly just used internally.
* The [get](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.get.html)
  and [set](https://www.kymorphia.com/taglib-d/taglib.tag_variant.TagVariant.set.html)
  templates can be used to get and set a TagVariant using D types.

### Saving

When tags have been changed with TagFile setter methods, the changes can be saved by calling the
[TagFile.save](https://www.kymorphia.com/taglib-d/taglib.tag_file.TagFile.save.html) method.

## Examples

Examples can be found in the [examples directory](examples/).

### Dub Config

To use taglib-d just add it to your project dependencies in your dub.json file.
For example:

```json
{
	"name": "My awesome D project using taglib-d",
	"description": "Super awesome",
	"copyright": "Copyright © 2025, D Wizard <wizard@d-rawks.biz>",
	"dependencies": {
    "taglib-d": "~>2.0.0"
	}
}
```

## DTagLib

[DTagLib](https://github.com/jpf91/DTagLib) is another D language binding for TagLib.
However, the last commit on this project was 14 years ago and it hasn't been updated to support the newer API.
It was therefore decided to create taglib-d as a separate project
and also for the purpose of having more creative freedom without concern for backwards compatibility.
