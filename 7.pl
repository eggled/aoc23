#!/usr/bin/env perl
use strict;
use v5.38;

sub score_list {
    my ($hand) = @_;
    my %count;
    $count{$_}++ for (grep /\w/, split //, $hand);
    return values %count;
}

sub score_hand {
    my ($hand) = @_;
    my $jokers = $hand =~ s/J//g;
    $DB::signal = 1;
    my @score_list = sort(score_list($hand));
    $score_list[-1] += $jokers if @score_list;
    @score_list = ($jokers) unless @score_list;
    my $sum = 0;
    $sum += (2**$_-1) for (@score_list);
    return $sum;
}

sub cmp_cards {
    my ($vala, $valb) = @_;
    return 0 if ($vala eq $valb);
    for my $t (qw(A K Q T)) {
        return 1 if ($vala eq $t);
        return -1 if ($valb eq $t);
    }
    return -1 if ($vala eq 'J');
    return 1 if ($valb eq 'J');
    return $vala <=> $valb;
}

sub cmp_hands {
    my $sccmp = score_hand($a->[0]) <=> score_hand($b->[0]);
    return $sccmp if ($sccmp);
    for (0..4) {
        my $cdcmp = cmp_cards(substr($a->[0],$_,1), substr($b->[0],$_,1));
        return $cdcmp if $cdcmp;
    }
    return 0;
}

my @hands;
while (defined($_=<>)) {
    my @fields;
    last unless @fields = m/(\w+)/g;
    push @hands, \@fields;
}

@hands = sort { cmp_hands() } @hands;
my $sum = 0;
for (1..@hands) {
    my $val = $hands[$_-1][1];
}
$sum += $hands[$_-1][1]*$_ for (1..@hands);
say $sum;
