# caryCompressionMIDICSV

This GitHub repo contains code that can convert between MIDICSV .csvs, and a compressed format of .txt file that's roughly 1/6 the size, which I will call "Cary-compressed".

Watch this video for explanation: https://www.youtube.com/watch?v=SacogDL_4JU (I wrote this in March 2017, and haven't really updated it since. Nowadays, I'd probably write this in Python, but oh well)

You'll need Processing 3 to run this code! https://processing.org/

You'll also need MIDICSV. https://www.fourmilab.ch/webtools/midicsv/. Remember that the OUTPUT of midicsv (.csv file) will become the INPUT of the Cary-compressor (which will then output a .txt file). Also, realize that the OUTPUT of the Cary-decompressor (.csv file) will become the INPUT of the csvmidi (which will then output a .mid file).

Anyway, MIDICSVTXT_TO_CARYCOMPRESSED.pde takes in midicsv .csv files, and converts them into cary-compressed .txt versions that are roughly 1/6 the size.
(Open MIDICSVTXT_TO_CARYCOMPRESSED.pde and edit the fileFolder and OUTPUT_FOLDER files to where the input midicsv .csv files are, and where you wany my compressed versions of these files to go.)

Same deal with CARYCOMPRESSED_TO_MIDICSVTXT.pde, in reverse: It takes in cary-compressed .txt files (which could be real human-composed pieces of music, OR outputs from some AI that is super messy), and tries to convert them back into MIDICSV files. This might fail if the inputted file is too corrupted, but usually, it'll work pretty well!


