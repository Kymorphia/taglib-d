/// Display named properties of TagLib supported media files
module named_props;

import std.array : array;
import std.algorithm : map, max, reduce, sort;
import std.conv : to;
import std.format : format;
import std.stdio : writeln;
import std.string : join;
import taglib;

void main(string[] args)
{
  if (args.length < 2)
  {
    writeln("Usage: ", args[0], " FILES");
    return;
  }

  // Loop over the filenames
  foreach (filename; args[1 .. $])
  {
    auto tagFile = new TagFile(filename);

    if (!tagFile.isValid)
    {
      writeln("File '", filename, "' is not a valid TagLib file");
      continue;
    }

    writeln("Named properties for file '", filename, "'");

    auto propValues = tagFile.getPropValues;
    auto maxKeyLength = propValues.keys.map!(x => x.length).reduce!max; // Get maximum width of all key names

    propValues.keys.array.sort // Sort the named property keys
      .map!(key => format("%-*s: %s\n", maxKeyLength, key, propValues[key].length == 1
      ? propValues[key][0] : propValues[key].to!string)) // Format the key names to lines with the key name and value (use single string values if only 1 value in array)
      .join // Join the lines
      .writeln; // Display them
  }
}
