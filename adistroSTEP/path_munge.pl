#!/usr/bin/perl -w

use File::Find;
use strict;

my $cwd = `pwd`;
local $/ = "\n"; 
chomp($cwd) if defined $cwd; 
$cwd;

find({wanted => \&process_file}, $cwd);
# find(\&process_file, $cwd);

sub process_file {
        -d $File::Find::name and return;
        print $File::Find::name, "\n"; 
        open (FILE, "+< $File::Find::name") 
        or (warn "Unable to open file: $!" and return);
        my $out = '';
	while(<FILE>) {
		if ($_ =~ m/bindir/) {
			print "Not clobbering bindir\n";
		} elsif ($_ =~ m/sbindir/) {
			print "Not clobbering sbindir\n";
		} elsif ($_ =~ m/\.h/) {
			print "Not clobbering header path\n";
		} else {
		s|/usr/bin|/System/Tools|g;
		s|/bin|/System/Tools/|g;
		s|/usr/sbin|/System/AdminTools|g;
		s|/sbin|/System/AdminTools|g;
		s|/dev|/System/Devices|g;
		s|/var/run/dev.db|/System/ApplicationData/RuntimeData/dev.db|g;
		s|/var/mail|/System/Mail|g;
		s|/var/db|/System/ApplicationData/Databases|g;
		s|/var/tmp|/System/ApplicationData/TemporaryFiles|g;
		s|/tmp|/System/TemporaryFiles|g;
		s|/proc|/System/Processes|g;
		s|/var/run|/System/ApplicationData/RuntimeData|g;
		s|/var|/System/ApplicationData|g;
		s|/boot|/System/Boot|g;
		s|/lib/modules/|/System/Drivers/|g;
		$out .= $_;  
		}
	}
        #print "$out\n";
        seek(FILE, 0, 0)
        or die "Can't seek to start of file: $!";
        print FILE $out
        or die "Can't print to file: $!";
        truncate(FILE, tell(FILE))
        or die "Can't close file: $!";
	close FILE;
    }


