#!/usr/bin/env perl


use strict;
use v5.38;

sub proc_map_v1 {
    my $cur_numbers = shift;
    1 until (defined($_=<>) and m/(\w+)-to-(\w+) map:$/);
    my ($from, $to) = ($1, $2);
    my %map = map { $_ => $_ } @$cur_numbers;
    while (defined($_=<>)) {
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

use List::Util qw(min max);

sub rstart {
    return $_[0]->[0];
}

sub rend {
    return $_[0]->[0]+$_[0]->[1];
}

sub rlen {
    return $_[0]->[1];
}

sub no_overlap {
    my ($test_range, $target_range) = @_;
    return 1 if rlen($test_range) == 0 or rlen($target_range) == 0;
    return 1 if rstart($test_range) > rend($target_range);
    return 1 if rend($test_range) < rstart($target_range);
    return 0;
}

sub left_overhang {
    my ($test_range, $target_range) = @_;
    return [] if (no_overlap($test_range, $target_range) or rstart($test_range) >= rstart($target_range));
    my $overhang_length = rlen($test_range);
    $overhang_length = rstart($target_range)-1 - rstart($test_range) if (rend($test_range) >= rstart($target_range));
    my $overhang_start = rstart($test_range);
    $test_range->[0] = $overhang_start+$overhang_length+1;
    $test_range->[1] -= $overhang_length;
    return [$overhang_start, $overhang_length];
}

sub right_overhang {
    my ($test_range, $target_range) = @_;
    return [] if (no_overlap($test_range, $target_range) or rend($test_range) <= rend($target_range));
    my $overhang_length = rlen($test_range);
    $overhang_length = rend($test_range) - (rend($target_range)+1) if (rstart($test_range) <= rend($target_range));
    my $overhang_start = rend($test_range) - $overhang_length;
    #$test_range->[0] = $overhang_start-($overhang_length+1);
    $test_range->[1] -= $overhang_length;
    return [$overhang_start, $overhang_length];
}

sub disp {
    my ($mention, $range) = @_;
    return [] unless rlen($range);
    say "$mention: ". join '..', rstart($range), rend($range);
    return $range;
}

sub proc_map {
    my $cur_numbers = shift;
    1 until (defined($_=<>) and m/(\w+)-to-(\w+) map:$/);
    my ($from, $to) = ($1, $2);

    my @map;
    while (length($_=<>) and m/\S/) {
        my @dig = grep {length} split /\s+/;
        push @map, \@dig;
    }
    
    my @outputs;
    while (my @rng = splice @$cur_numbers, 0, 2) {
            $DB::signal = 1 if (rstart(\@rng) == 57  and rend(\@rng) == 70);
        for my $loc (@map) {
            my $test_range = [@{$loc}[1,2]];
            disp("Checking: ",\@rng);
            disp("Against: ",$test_range);
            next if no_overlap(\@rng, $test_range);
            unshift @$cur_numbers, @{disp("Left", left_overhang(\@rng, $test_range))};
            unshift @$cur_numbers, @{disp("Right", right_overhang(\@rng, $test_range))};
            next unless rlen(\@rng);
            disp("$to Overlap: ", \@rng);
            say "Add: ".($loc->[0]-$loc->[1]);
            push @outputs, $rng[0] + $loc->[0]-$loc->[1], $rng[1];
            $rng[1] = 0;
            last;
        }
        push @outputs, @rng if (rlen(\@rng));
    }
    @$cur_numbers = @outputs;
    say "Expanded to: ".join ',', @$cur_numbers;
    say '';
    return $to;
}

my @cur_numbers;
while ($_=<>) {
    last if @cur_numbers = grep {length} split /\s+/, s/^seeds:\s*//r;
}

my $value = '';
$value = proc_map(\@cur_numbers) until ($value eq 'location');
my %lkp = @cur_numbers;
my ($min) = min(keys %lkp);
say $min;

# 107430936 for the short one using v1
