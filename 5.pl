#!/usr/bin/env perl


use strict;
use v5.38;

sub proc_map {
    my $cur_numbers = shift;
    1 until (defined($_=<>) and m/(\w+)-to-(\w+) map:$/);
    my ($from, $to) = ($1, $2);
    my %map = map { $_ => $_ } @$cur_numbers;
    while ($_=<>) {
        last unless m/\S/;
        my @dig = grep {length} split /\s+/;
        for my $test (@$cur_numbers) {
            next if $test < $dig[1];
            next if $test-$dig[1]>$dig[2];
            $map{$test} = $test + $dig[0]-$dig[1];
        }
    }
    map { say "$from $_ => $to $map{$_}" } sort keys %map;
    @$cur_numbers = values %map;
    return $to;
}

my @cur_numbers;
while ($_=<>) {
    last if @cur_numbers = grep {length} split /\s+/, s/^seeds:\s*//r;
}

my $value = '';
$value = proc_map(\@cur_numbers) until ($value eq 'location');
my ($min) = sort { $a <=> $b } @cur_numbers;
say $min;

# 107430936
