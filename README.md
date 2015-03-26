# reBar
Perl wrapper script (reBar.pl) and installation and usage instructions for using ZBar (a software package for reading barcodes from various sources) to rename a batch of natural history specimen image files based on one dimensional barcodes that are visible in an image files.

Execution of reBar.pl will loop through JPEG files in a directory, use ZBar (http://zbar.sourceforge.net/) to find barcode in JPEG file, and then copy the JPEG and corresponding archival file (e.g., a DNG) to new folder, using the found barcode value as the filename.

The script assumes image directory will have JPEGs and an archival file of a different format, both with the same original name (minus the extension). An expectation is that the barcodes will contain data typical of that found in natural history specimen barcodes (i.e., a collection code plus a locally unique number - 'ABC12345678').

Renamed files will be copied to a new directory ("renamed_date+time") within the directory containing the original files. The original files are not deleted. In the directory containing the original image files, a log file will be created (csv formatted) reporting success or failure for each file.

If multiple barcodes are in the original image (i.e., multiple barcodes on a sheet), a separate JPEG image and archival image will be created for each barcode/specimen (this logic assumes one barcode per specimen). 

Requires Zbar (http://zbar.sourceforge.net), ImageMagick (http://www.imagemagick.org/), and perl (https://www.perl.org/).

The script has been tested on Windows (7 & 8), Fedora (19), and OS X (10.7.5).

See INSTALLATION.txt for installation and configuration instructions and USAGE.txt for instructions on usage.
