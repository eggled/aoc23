#!/usr/bin/env perl
use strict;
use v5.38;

sub score_hand {
    my ($hand) = @_;
    my %count;
    $count{$_}++ for (grep /\w/, split //, $hand);
    my $sum = 0;
    $sum += (2**$_-1) for (values %count);
    return $sum;
}

sub cmp_cards {
    my ($vala, $valb) = @_;
    return 0 if ($vala eq $valb);
    for my $t (qw(A K Q J T)) {
        return 1 if ($vala eq $t);
        return -1 if ($valb eq $t);
    }
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
    say "rank $_: $val * $_ = ".($val * $_);
}
$sum += $hands[$_-1][1]*$_ for (1..@hands);
say $sum;
