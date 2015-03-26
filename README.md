# reBar
Perl wrapper script (rebar.pl) and installation and usage instructions for using ZBar (a software package for reading barcodes from various sources) to rename a batch of image files based on one dimensional barcodes that are visible in an image files.

Requires Zbar (http://zbar.sourceforge.net), ImageMagick (http://www.imagemagick.org/), and perl (https://www.perl.org/).

The script has been tested on Windows (7 & 8), Fedora (19), and OS X (10.7.5).

Execution of rebar.pl will loop through JPEG files in a directory, use ZBar (http://zbar.sourceforge.net/) to find barcode in JPEG file, and then copy the JPEG and corresponding archival file (e.g., a DNG) to new folder, using the found barcode value as the filename. The script assumes image directory will have JPEGs and an archival file of a different format, both with the same original name (minus the extension). If multiple barcodes are in the original image (i.e., multiple barcodes on a sheet), a separate JPEG image and archival image will be created for each barcode/specimen (this logic assumes one barcode per specimen). Renamed files will be copied to a new directory ("renamed_date+time") within the directory containing the original files. The original files are not deleted. In the directory containing the original image files, a log file will be created (csv formatted), and it will report success or failure for each file.
