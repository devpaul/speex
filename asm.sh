#!/usr/bin/env bash

# If you haven't already build and install emscripten
# see: http://webassembly.org/getting-started/developers-guide/
#
# make sure you've set your emscripten environment variables by running source ./emsdk_env.sh

WASM=${1:-0}
JSOUT=$((WASM == 0 ? "libspeex.asm.js" : "libspeex.wasm.js"))
PREFIX=`pwd`\test_install
EXPORTED="['_nb_decode','_nb_decoder_ctl','_nb_decoder_init']"

if [ $WASM == 0 ]
then
	JSOUT=libspeex.asm.js
else
	JSOUT=libspeex.wasm.js
fi

echo ${EXPORTED};
emconfigure ./configure --disable-shared --enable-static --prefix=$PREFIX CFLAGS=\"-s WASM=${WASM}\"
emmake make
cd libspeex
emcc cb_search.o exc_10_32_table.o exc_8_128_table.o filters.o gain_table.o hexc_table.o high_lsp_tables.o lsp.o \
	ltp.o speex.o stereo.o vbr.o vq.o bits.o exc_10_16_table.o exc_20_32_table.o exc_5_256_table.o exc_5_64_table.o \
	gain_table_lbr.o hexc_10_32_table.o lpc.o lsp_tables_nb.o modes.o modes_wb.o nb_celp.o quant_lsp.o sb_celp.o \
	speex_callbacks.o speex_header.o window.o -s EXPORTED_FUNCTIONS=${EXPORTED} -s WASM=${WASM} \
	-I. -I.. -I../include -I../include/speex -DFLOATING_POINT -o ${JSOUT}
