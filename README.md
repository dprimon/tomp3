The code consists in two functions.

# Dependencies

Packages like shntool, ffmpeg and flac are needed at minimum. In debian you can install them with: 

`$ sudo apt install shntool ffmpeg flac`.

You may also need a program to tag source music files. I personally like and use kid3.

# Install

Source the bash file in your shell like 

`$ . flac-to-mp3.sh`

Available functions:

# tomp3

One to encode several audio files from a single album which are supposed to be tagged properly. To encode you must cd to the directory containg the files to be encoded and issue `$ tomp3 <sourceFileExtension>`

For example the following encodes flac files to a subdirectory which will contain encoded mp3s:

## Example 

`$ time tomp3 flac`

Note: the source files must be tagged and the filenames following the form `"<trackNumber> - Filename.<extension>"`. In the example, `<extension>`=flac. `time` is prepended to show total time of execution.

# split_cue_flac

Must be run in the directory containing the single album file and the corresponding cue file.

## Example

`$ split_cue_flac "Prince - Purple Rain.cue" "Prince - Purple Rain.flac"`

