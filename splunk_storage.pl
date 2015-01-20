#!/usr/bin/perl

use Getopt::Long;

my %opt;

$opt{repfactor} = 1;
$opt{srchfactor} = 1;
$opt{frozen} = 0;

GetOptions(\%opt,
	'repfactor|r=i' => 'repfactor',
	'srchfactor|s=i' => 'srchfactor',
	'daily|d=i' => 'daily',
	'retention|t=i' => 'retention',
	'indexers|i=i' => 'indexers',
	'frozen|f=i' => 'frozen'
);

print "Splunk Indexer Configuration\n";
print "Number of Indexers\t\t: ".$opt{indexers}."\n";
print "Replication Factor\t\t: ".$opt{repfactor}."\n" if $opt{repfactor} > 1;
print "Search Factor\t\t\t: ".$opt{srchfactor}."\n" if $opt{repfactor} > 1;
print "Daily Data Rate (GB)\t\t: ".$opt{daily}."\n";
print "Retention Time (days)\t\t: ".$opt{retention}."\n";
print "Frozen Data Retention (days)\t: ".$opt{frozen}."\n" if $opt{frozen} > 0;
print "\n";

$total_daily_data = ( $opt{daily} * 0.15 * $opt{repfactor} ) + ( $opt{daily} * 0.35 * $opt{srchfactor} );
$total_daily_per_indexer = $total_daily_data / $opt{indexers};
$total_indexer_size = $total_daily_per_indexer * $opt{retention};

$total_daily_frozen = $opt{daily} * 0.15;
$total_daily_frozen_per_indexer = $total_daily_frozen / $opt{indexers};
$total_indexer_frozen = $total_daily_frozen_per_indexer * $opt{frozen};

print "Sizing Results\n";
print "Total Daily Data Per Indexer\t\t: ";
printf "%.2fGB\n",$total_daily_per_indexer;
print "Total Daily Frozen Data Per Indexer\t: " if $opt{frozen} > 0;
printf "%.2fGB\n",$total_daily_frozen_per_indexer if $opt{frozen} > 0;
print "Total Size per Indexer\t\t\t: ";
printf "%.2fGB\n",$total_indexer_size + $total_indexer_frozen;
print "Total Overall Online Data\t\t: ";
printf "%.2fGB\n",$total_indexer_size * $opt{indexers};
print "Total Overall Frozen Data\t\t: " if $opt{frozen} > 0;
printf "%.2fGB\n",$total_indexer_frozen * $opt{indexers} if $opt{frozen} > 0;
