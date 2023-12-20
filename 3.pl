#!/usr/bin/env perl

use strict;
use v5.38;

my $l = <>;
my $ll;

my $sum=0;

my $nl;
close STDIN;
my %symtrak;
while ((defined($nl = <>)) or length $l) {

    while ($l =~ m/(\d+)/g) {
        my $num = $1;
        my $lbound = pos($l)-length$num;
        my $rbound = pos($l)+1;
        $lbound-- if ($lbound);

        my $linenum=$.-3;
        $linenum++ unless defined $nl;
        my $tnum = $num;
        for ($ll, $l, $nl) {
            $linenum++;
            next unless length;
            my $test = substr($_, $lbound, $rbound-$lbound);
            $sum+= $num and $num=0 if ($test =~ m/[^\d\.\n]/);
            while ($test =~ m/\*/g)
            {
                my $offset = pos($test)-1+$lbound;
                push @{$symtrak{$linenum}{$offset}}, $tnum;
                say "\t$tnum is touching one at $linenum, $offset";
            }
        }
    }

    ($ll, $l)=($l, $nl);
}
say $sum;

my $ratio = 0;

for my $val (grep { @$_ == 2 } map { values %$_ } values %symtrak) {
    say "\tfound one touching $val->[0] and $val->[1]";
    $ratio += $val->[0]*$val->[1];
}
say $ratio;



# Appears this is wrong. 527602 is too low. 
# 526457 is right out, then - but I was counting some shit at the end of rows because of newlines "looking" like symbols.
# ...OK, but the internet thinks my second answer is spot on...
#
# ... I copied the wrong data :'(  528819...
#
# part 2: 78971290 is too low
# Got it - I was miscategorizing some at the edges: 79417186 (Also too low -_-)
# Last row: $. didn't get incremented so row indices were "squished". 80403602 is it.
