# caryCompressionMIDICSV

This GitHub repo contains code that can convert between MIDICSV .csvs, and a compressed format of .txt file that's roughly 1/6 the size, which I will call "Cary-compressed".

Watch this video for explanation: https://www.youtube.com/watch?v=SacogDL_4JU (I wrote this in March 2017, and haven't really updated it since. Nowadays, I'd probably write this in Python, but oh well)

You'll need Processing 3 to run this code! https://processing.org/

You'll also need MIDICSV. https://www.fourmilab.ch/webtools/midicsv/. Remember that the OUTPUT of midicsv (.csv file) will become the INPUT of the Cary-compressor (which will then output a .txt file). Also, realize that the OUTPUT of the Cary-decompressor (.csv file) will become the INPUT of the csvmidi (which will then output a .mid file).

To run the compressor code, open MIDICSVTXT_TO_CARYCOMPRESSED/MIDICSVTXT_TO_CARYCOMPRESSED.pde in Processing, change the filepaths at the top few lines, and click "Run".

To run the decompressor code, open CARYCOMPRESSED_TO_MIDICSVTXT/CARYCOMPRESSED_TO_MIDICSVTXT.pde, change the filepaths at the top few lines, and click "Run".
