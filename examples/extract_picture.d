/// Extract a picture from a TagLib supported media file and save it to the specified file name
module extract_picture;

import std.array : array;
import std.algorithm : sort;
import std.stdio : writeln;
import taglib;

// File extensions to use for different image mime types
immutable string[string] mimeExtensions = [
  "image/bmp": "bmp",
  "image/jpg": "jpg",
  "image/jpeg": "jpg",
  "image/png": "png",
];

void main(string[] args)
{
  if (args.length != 3)
  {
    writeln("Usage: ", args[0], " MediaFile OutputPicFileNoExt");
    return;
  }

  auto filename = args[1];
  auto picFilename = args[2];
  auto tagFile = new TagFile(filename);

  if (!tagFile.isValid)
  {
    writeln("File '", filename, "' is not a valid TagLib file");
    return;
  }

  auto pictureProps = tagFile.getComplexProp("PICTURE");

  if (pictureProps.length > 0)
  {
    writeln("PICTURE:");

    foreach (k, v; pictureProps) // Loop over the key/value pairs in the PICTURE map
      writeln("  ", k, ": ", v);

    writeln;

    auto ext = mimeExtensions.get(pictureProps["mimeType"].get!string, "pic");
    writeln("Saving image to '", picFilename, ".", ext, "'");

    import std.file : write;
    write(picFilename ~ "." ~ ext, pictureProps["data"].getByteArray);
  }
  else
    writeln("File '", filename, "' has no PICTURE property");
}
