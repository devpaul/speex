# Speex

## Build

### Mac

#### Production

* install dependencies
	* autoconf automake libtool
* ./autoconf.sh
* ./configure
* make

#### Debug

* install dependencies
	* 'libogg' from https://www.xiph.org/downloads/
* ./autogen.sh
* CFLAGS=-g ./configure
	* setting the GCFLAGS environment variable compiles binary with debugging symbols and prevents many optimizations from changing code in ways that make debugging hard
* make

* debugging with VS Code
	* select debug mode
	* create a launch profile (environment = C++ (GDB/LLDB))
	* change program to `${workspaceRoot}/src/.libs/speexdec`
	* change cwd to `${workspaceRoot}/src/.libs`
	* add at least two args
		* First arg is fully-qualified path to input file.
		* Second arg is path to output file. Add `.wav` suffix to generate wav file
	* start debugger (Debug mode -> Green play button or <F5>)

### XCode

* open speex/macos/Speex.xcodeproj
* Change Base SDK
	* Click Project tab in left frame
	* Select Speex project
	* Build Settings in center frame
	* Select "All" tab
	* Under Architectures > Base SDK; change to Latest macOS
* From the terminal
	* ./autoconf.sh
	* ./configure
* Add config.h
	* Right-click on "Speex > Headers" > Add files to "Speex" > add config.h
* Add HAVE_CONFIG_H
	* Open Build Settings again
	* Search for "OTHER_CFLAGS"
	* Add `-DHAVE_CONFIG_H=1` to Debug and Release
* Build
	* Outputs `Speex.framework`

### Windows with Visual Studio (debug build)

* compile libogg
	* download libogg from http://downloads.xiph.org/releases/ogg/libogg-1.3.2.zip
	* unzip libogg-1.3.2.zip
	* open libogg-1.3.2\win32\vs2010\libogg_dynamic.sln in Visual Studio
		* confirm dialog to "Retarget Projects" if prompted
		* right click on the libogg project in th `libogg_dynamic` solution (in Solution Explorer) and select `build`
* compile speexdec
	* open `{speexDirectory}\win32\VS2008\libspeex.sln` in Visual Studio
	* confirm one-way upgrade when prompted
		* several projects will not convert properly, this is okay
		* if prompted to convert without 'Windows Mobile 5.0 ...' platform, confirm request to continue conversion without the platform
	* close the conversion report when it appears
	* remove the following projects (right click on them in Solution Explorer and click `Remove`)
		* libspeexdsp
		* testdenoise
		* testecho
		* testresample
		* testenc
		* testenc_uwb
		* testenc_wb
	* add location of `ogg.h` to include directories
		* right click on `libspeex` in Solution Explorer and select `Properties`
		* Click on `VC++ Directories` under the `Configuration properties` section
		* Edit the `Include Directories` entry
			* add an entry for the location of the `ogg.h` file
				* `{oggDirectory}\include`
		* repeat process for the `speexdec` project
	* add linker reference to `libogg.lib`
		* right click on the `speexdec` project in the Solution Explorer and select `Properties`
		* Open Configuration Properties -> Linker -> Input
		* Edit the Additional Dependencies option
			* add an entry for `libogg.lib`
				* `{oggDirectory}\win32\VS2010\Win32\Debug\libogg.lib`
	* build the solution
		* Right click on the solution in the Solution Explorer and select "Rebuild Solution"
	* add `libogg.dll`
		* copy `libogg.dll` to the output directory
			* source `{oggDirectory}\win32\VS2010\Win32\Debug\libogg.dll`
			* destination `{speexDirectory}\win32\VS2008\Debug`
	* set `speexdec` as the startup project
		* right click on the `speexdec` project in the Solution Explorer and select "Set as StartUp Project"
	* set the debugger arguments
		* right click on the `speexdec` project in the Solution Explorer and select `Properties`
		* Navigate to Configuration Properties -> Debugging
		* edit the Command Arguments entry to include the arguments
			* these are listed as they would be on the command line - they don't have to be quoted, etc
			* two arguments are required - the input file and the output name
				* example: `{jlgDirectory}\support\assets\audio\securus_demo_rtmr_audio\83258.spx .\out.wav`
	* set breakpoints at desired locations
	* run debugger with <F5> key
		* if debugger fails to stop at a break point, it is possible that the debugging database (`.pdb` file) was misnamed. To set the name:
			* Right click on `speexdec` in Solution Explorer and select `Properties`
			* Navigate to Configuration Properties -> LInker -> Debugging
			* ensure that the Generate Program Database File entry is `$(OutDir)speexdec.pdb`
			* rebuild and try to run again

## Speex Decoder

From src/speexdec.c

* process_header()
	* speex_lib_get_mode(modeID)
	* speex_decoder_init(mode)
	* speex_decoder_ctl(...)
* speex_bits_read_from(&bits, op.packet, op.bytes)
* loop over frames
	* ret = speex_decode_int(st, &bits, output)
	* speex_decode_stereo_int(output, frame_size, &stereo)
