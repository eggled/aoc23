#!/usr/bin/env perl

use strict;
use v5.38;

my @input = <>;
my @times = map { /(\d+)/g } grep m/^Time/, @input;
my @dist = map { /(\d+)/g } grep m/^Distance/, @input;


my $prod = 1;
for my $idx (0..$#times) {
    my $wins = 0;
    my $time = $times[$idx];
    for my $btime (1..$time-1) {
        next unless $btime*($time-$btime)>$dist[$idx];
        $wins++ if $btime*($time-$btime)>$dist[$idx];
    }
    $prod *= $wins;
}
say $prod;


