# elp2pdf
Emulated line printer output to PDF

Perl scripts to convert emulated line printer output to PDF documents on Linux.

The main script calls two programs that must be installed:

- enscript
- ghostscript

Setup:

- place dot_enscriptrc in the user home directory as .enscriptrc
- edit .enscriptrc and replace "emulator" on the first line with the user name
- create a .enscript directory in the home directory
- put the modified enscript prolog "enscript.pro" in .enscript
- place elp2pdf.pl, elp-default.pl and any other script files for specific systems to a same directory

elp2pdf can read from one of these sources:

- standard input (stdin)
- file
- file being written to continuously (tail mode)
- IP socket

If elp2pdf is to run tailored to a specific sytem, it will attempt to detect the end of a job to convert each complete job to its own PDF. It will also attempt to capture information such as the job name and timestamp to name the PDF file. If no end of job is detected, it will create a PDF at the end of a configurable timeout period (default behavior).

The default font is Courier12 but other monospaced fonts can be used. They must exist in a location where ps2pdf (Ghostscript) can find them such as /usr/share/ghostscript/fonts/. The font pitch and the baselineskip parameter will need to be adjusted.
<PRE>
Usage:

./elp2pdf.pl [OPTION]... [FILE]
With no FILE, or when FILE is -, read standard input.
--lptype       | -l line printer type
--color        | -c bar color, default: 1
    0: borders only, 1: green, 2:blue, 3:orange, 4:gray
--font         | -f font, default: Courier12
--bar-height   | -h lines per bar, default: no bars
--ip           | -i host
--port         | -p port
--tail         | -t tail file
--system-id    | -s system ID
--name         | -n printer name
--path         | -P output path, default: current directory
--border-style | -S border style, default: 0
    0: normal, 1: first bar is 5 lines, 2: no border
--baselineskip | -b baseline skip
--start-line   | -L print start line on page, default: 4
--wait         | -w wait time to close file in seconds, default: 3
--y-shift      | -y vertical bars and border shift, +/- 192 units per line

Examples:

elp2pdf.pl -t -n prt1 -P ~/printout -c 1 -w 30 lpt.prn
        Default conversion (elp-default.pl),
        read from lpt.prn file and tail,
        printer name is prt1 (appears in PDF file name),
        3 line high green bar background,
        30 second timeout to cut the print job to a PDF.

elp2pdf.pl -l mvs -s SYS1 -n 00e -i localhost -p 1403 -f LiberationMono-Bold.ttf12
        Conversion for MVS JES2 systems (elp-mvs.pl),
        read from port 1403 on current computer,
        system name is SYS1, printer name is prt1,
        use LiberationMono Bold font.<PRE/>
