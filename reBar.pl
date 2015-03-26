#!/usr/bin/perl -w
#
# reBar.pl vers. 0.9
#
# Script to loop through jpg files in a directory, use ZBar to find barcode in jpg,
# and then copy jpg and corresponding archival file to new folder, using the barcode as the filename.
#
# Needs ZBar software suite: http://zbar.sourceforge.net/.
# Assumes image directory will have jpgs and archival files, both with the same name (minus the extension).
# If multiple barcodes are in original image (i.e., multiple barcodes on a sheet), a separate jpg image and archival image
# will be created for each barcode/specimen (this logic assumes one barcode per specimen).
#
# Author: Patrick W. Sweeney, Yale Peabody Musuem of Natural History
#
#-----LISCENSE-----
# You may use this software under the terms of the MIT License:
#
# The MIT License (MIT)
# Copyright (c) 2014 Yale Peabody Musuem of Natural History
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge, 
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or 
# substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# DEALINGS IN THE SOFTWARE.
#----------

use POSIX qw/strftime/;
use Cwd;
use File::Copy qw(copy);
binmode STDOUT, ":encoding(UTF-8)";

#*****MODIFY THESE VARIABLES*****
my $zbar = 'C:\Program Files (x86)\ZBar\bin\zbarimg'; #Change path to zbarimg application path.
my $symbology = 'code39.enable'; #Default symbology is Code 39. Visit http://zbar.sourceforge.net/ for more info about symbologies.
my $archive = ".tif"; #File extension for archive format.
# change regular expression on line 78
#********************************

my $version = '0.9';
my $directory = getcwd(); #current working directory
my $date = strftime("%Y-%m-%d-%H%M%S", localtime); #current date plus time

open (STDERR, ">>", "$directory/renameLog_$date.csv"); #redirect STDERR to log file
$| = 1; # turn on buffer autoflush for log output
print STDERR "filename,barcode,renamedJPG,renamedArchive,status\n"; #log file header

#-----make directory for re-named images
mkdir("renamed_$date",0777) unless(-d "renamed_$date" ); #permissions don't work on Windows

open (OUTFILELOG, ">>", "$directory/renameLog_$date.csv") || die "ERROR: opening renamed_$date/renameLog_$date.csv\n"; #open logfile

opendir (DIR, $directory) or die $!; #open current working directory directory

#-----loop through files in directory
while (my $file = readdir(DIR)) {
	next unless ($file =~ m/\.(jpg|jpeg)$/);
	#-----use system call to run ZBar application to fetch barcode(s) from image and place them into an array
	my @barcode = qx("$zbar" -q --raw -Sdisable -S"$symbology" "$file");
	
	#-----if barcode found, proceed
	if (@barcode) {
		#-----loop through array of barcodes
		foreach my $barcode (@barcode) {
			print OUTFILELOG "$file,";
			chomp($barcode);
			print OUTFILELOG "$barcode,";
			if ($barcode =~ m/^(YU.)(\d{6})$/) { #*****Change regular expression to match collection's barcode format*****
				#-----copy jpg file to new directory, use barcode as filename. If successful, copy dng.
				my $copy_jpg_status = copy($file, "renamed_$date/$barcode.jpg");
				if ($copy_jpg_status)
				{
					print OUTFILELOG "$barcode.jpg,";
			
					#-----copy dng file to new directory, use barcode as filename
					my $archive_file = $file;
					$archive_file =~ s/\.jpg/$archive/g;
					my $copy_archive_status = copy($archive_file, "renamed_$date/$barcode$archive") or die "Copy failed: $!";
					if ($copy_archive_status) {
						print OUTFILELOG "$barcode$archive,SUCCESS\n";
					}
					else
					{
						print OUTFILELOG "unable to create $archive_file!,FAIL\n";
					}	
				}
				else
				{
					print OUTFILELOG "unable to create $barcode.jpg!,$barcode.dng not created,FAIL\n";
				}
			} else {
				print OUTFILELOG $barcode . " is wrong format!,jpg not created,dng not created,FAIL\n";
			}
		}
	}
	else
	#-----if no barcode found, report failure
	{
		print OUTFILELOG "$file,,,,FAIL: No barcode found.\n";
	}
 }
 closedir(DIR);
 exit 0;





