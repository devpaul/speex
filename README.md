# Speex

## Build

### Mac

* install dependencies
	* autoconf automake libtool
* ./autoconf.sh
* ./configure
* make

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
