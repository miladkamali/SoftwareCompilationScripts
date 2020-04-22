#!/usr/bin/perl
my $numMinutes=0;
my $numSeconds=0;
my $numHours=0;
foreach $line (<>) 
{

	my ($tempSeconds) = $line =~ /(\d+) s/;
	my ($tempMinutes) = $line =~ /(\d+) min/;
  my ($tempHours) = $line =~ /(\d+) hour/;
	$numSeconds+=$tempSeconds;
	$numMinutes+=$tempMinutes;
	$numHours+=$tempHours;
}
use integer;
$numSeconds/=3;
$numMinutes/=3;
$numHours/=3;
$numMinutes += $numSeconds/60;
$numHours += $numMinutes/60;

$numMinutes=$numMinutes%60;
$numSeconds=$numSeconds%60;
print $numHours," hours ",$numMinutes," min  ",$numSeconds," s \n";

