/// Display basic properties of TagLib supported media files
module basic_props;

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

    writeln("File: ", filename);
    writeln("Title: ", tagFile.title);
    writeln("Artist: ", tagFile.artist);
    writeln("Album: ", tagFile.album);
    writeln("Comment: ", tagFile.comment);
    writeln("Genre: ", tagFile.genre);
    writeln("Year: ", tagFile.year);
    writeln("Track: ", tagFile.track);
    writeln("Length: ", tagFile.length, " seconds");
    writeln("Bitrate: ", tagFile.bitrate, " kb/s");
    writeln("Samplerate: ", tagFile.samplerate, " Hz");
    writeln("Channels: ", tagFile.channels);
    writeln;
  }
}
