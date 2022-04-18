#!/usr/bin/perl
#use strict;
#use warnings;
use Time::HiRes;
use POSIX 'strftime';

use Cwd qw(cwd);
my $curdir = cwd;
require($curdir."/settings.ini");

my $reporting_interval = 0.3; # seconds
my $bytes_this_interval = 0;
my $start_time = [Time::HiRes::gettimeofday()];

STDOUT->autoflush(1);
while (<>) {
        if (/ length (\d+):/) {
                $bytes_this_interval += $1;
                my $elapsed_seconds = Time::HiRes::tv_interval($start_time);
                if ($elapsed_seconds > $reporting_interval) {
                        my $bps = $bytes_this_interval / $elapsed_seconds;
                        if ($debugprint == 1) {
                                printf "%02d:%02d:%02d %10.2f Bps\n", (localtime())[2,1,0],$bps;
                        }
                        $start_time = [Time::HiRes::gettimeofday()];
                        $bytes_this_interval = 0;

                        my $date = strftime '%Y-%m-%d-%H-%M-%S', localtime;
                        if ($bps >= $bps_to_dump) {
                                printf($date." Dumping network traffic (".$interface.") to file. >=".$bps_to_dump." BPS\n".$date." File name: ".$dumps_directory."/attacklog-".$date.".pcap [YYYY-MM-DD-HH-MM-SS]\n");
                                system("tcpdump -i ".$interface." -c ".$packet_dump_size." -w ".$dumps_directory."/attacklog-".$date."_.pcap");
                                printf($date." Sleeping to prevent dumping too often.\n");
                                sleep($time_sleep_after_dump);
                        }

                }
        }
}
