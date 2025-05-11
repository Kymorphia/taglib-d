/// Display complex properties of TagLib supported media files
module complex_props;

import std.array : array;
import std.algorithm : sort;
import std.stdio : writeln;
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

    writeln("Complex properties for file '" ~ filename ~ "'");

    auto complexValues = tagFile.getComplexPropValues;

    foreach (mapName; complexValues.keys.array.sort) // Loop over each of the complex value maps sorted by map key name
    {
      auto complexMap = complexValues[mapName];

      writeln("Complex property: ", mapName);

      foreach (k, v; complexMap) // Loop over the key/value pairs in the map
        writeln("  ", k, ": ", v);
    }

    writeln;
  }
}
