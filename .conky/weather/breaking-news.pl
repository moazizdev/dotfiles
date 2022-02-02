#!/usr/bin/perl -w

############################
# Creator: Jeff Israel
#
# Script:	./simple-rss-reader-v3.pl
# Version: 	3.001
#
# Coded for for Wikihowto http://howto.wikia.com
#
# Description: 	This code downloads an RSS feed, 
# 		extracts the <title> lines,
# 		cleans them up lines,
# 		prints the pretty lines
# 		exits on max-lines
# Usage:
# .conkyrc: ${execi [time] /path/to/script/simple-rss-reader-v3.pl}
#
# Usage Example
# ${execi 300 /path/to/script/simple-rss-reader-v3.pl}
#

use LWP::Simple;


############################
# Configs
#

#$rssPage = "http://tvrss.net/feed/combined/";
$rssPage = "https://feeds.bbci.co.uk/arabic/rss.xml";
$numLines = 10;
$maxTitleLenght = 35;

###########################
# Code
#

# Downloading RSS feed
my $pageCont = get($rssPage);

# Spliting the page to lines
@pageLines = split(/\n/,$pageCont);

# Parse each line, strip no-fun data, exit on max-lines
$numLines--; #correcting count for loop
$x = 0;
foreach $line (@pageLines) {
	if($line =~ /\<title\>/){ # Is a good line?
		#print "- $line\n";
		$lineCat = $line;
		$lineCat =~ s/.*\<title\>//;
		$lineCat =~ s/\<\/title\>.*//;
		$lineCat =~ s/\[.{4,25}\]$//; # strip no-fun data ( [from blaaa] )
		$lineCat = substr($lineCat, 0, $maxTitleLenght);
		print "- $lineCat \n";
		$x++;
	}
	if($x > $numLines) {
		last; #exit on max-lines
	}
	
}

#print $page;
#print "\nBy Bye\n";
