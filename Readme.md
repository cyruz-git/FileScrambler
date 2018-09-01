# FileScrambler

**PLEASE NOTE THAT THIS IS BETA SOFTWARE. I'M IN NO WAY RESPONSIBLE FOR ANY DATA LOSS.**

*FileScrambler* is a small app that is useful for camouflaging files so that non-tech-savvy people will not know their contents.
It renames files and folder scrambling their name and it swaps some bytes of the file headers so that they are not recognizable by the associated programs.

Just drag & drop the desired files/directories on the main window and press **"s"** to start the scheduled job or **"c"** to cancel.
To descramble, repeat the same operation with the scrambled files.

Subsequent drag & drop operations without starting a job, will erase the previous scheduled job, preparing a new one.

### How it works

*FileScrambler* collects files and directories looping through the drag & dropped one and creating a list.
It parses the list and works on the files first and then the directory that contains them.
It swaps some of the file header bytes (default is 16), word by word (0x441A becomes 0x1A44). It renames the file/directory following a simple reversable char table.

All the scrambling and swap operations are reversable, so files and directories come back to the origin if they are worked through the program again.

### Disclaimer

I'm not responsible for any kind of data loss derived by the usage of this program. Please test if it's working for your use case with some garbage files first.

### Download

The build archive is [here on GitHub](https://github.com/cyruz-git/FileScrambler/releases).

### Files

Name | Description
-----|------------
COPYING | GNU General Public License.
COPYING.LESSER | GNU Lesser General Public License.
FileScrambler.ahk | Main and only source file.
FileScrambler.ico | Icon file.
README.md | This document.

### Configurable options

The program has some configurable options (the program must be recompiled or used as a script):

Variable | Description
---------|------------
SCRIPTLOGENA | [1/0] Enable logging (enabled by default).
SCRIPTLOGFILE | [path_to_file] Path to the log file (default to SCRIPTDIRECTORY\FileScrambler-Debug_YYYYMMDDHH24MISS.log).
ADDSYSFILES | [1/0] Enable working on system files (disabled by default).
BYTESTOSWAP | [n] Number of bytes to swap (default to 16).
CHARTABLE | [ss1 ss2 ... ssN] Table containing the substitution sets. Each set must be reversable (eg: if "8" replaces "e", "e" must replace "8", so the table must contain "e8 8e").

### How to compile

*FileScrambler* should be compiled with the **Ahk2Exe** compiler, that can be downloaded from the [AHKscript download page](http://ahkscript.org/download/).

Browse to the files so that the fields are filled as follows:

    Source:      path\to\FileScrambler.ahk
    Destination: path\to\FileScrambler.exe
    Custom Icon: path\to\FileScrambler.ico

Select a **Base File** indicating your desired build and click on the **> Convert <** button.
