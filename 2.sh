perl -nE '$id=$1 if s/Game (\d+): //; map { %d=(); s/(\d+) (\w)/$d{$2}=$1/ge; next if $d{r}>12 or $d{g}>13 or $d{b}>14; } split /;/; $s+=$id; END{say $s}' input
perl -MList::Util=reduce -nE 's/Game \d+: //; %p=(); map { s/(\d+) (\w)/$p{$2}=$1>$p{$2}?$1:$p{$2}/ge } split /;/; $s+=reduce {$a*$b} values %p; END{say $s}' input
