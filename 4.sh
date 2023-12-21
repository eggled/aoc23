perl -nE '@a=split /\s+/,s/.*:\s*|\s*\|.*//gr;@b=split /\s+/,s/.*\|\s*//r;$sum+=eval{2**((scalar(grep {join(",","",@a,"")=~m/,$_,/}@b)||die)-1)};END{say $sum}' "$@"

#perl -nE '@a=split /\s+/,s/.*:\s*|\s*\|.*//gr;@b=split /\s+/,s/.*\|\s*//r;$count=scalar(grep {join(",","",@a,"")=~m/,$_,/}@b);say 1+$arg[0];$sum+=$count*(1+pop @arg);map { @arg<$_?push @arg,2:$arg[$_-1]++}(1..$count); END{say $sum}' "$@" # 21 for test; should be 30.

perl -nE 'next unless /\S/;@a=split /\s+/,s/.*:\s*|\s*\|.*//gr;@b=split /\s+/,s/.*\|\s*//r;$win=scalar(grep {join(",","",@a,"")=~m/,$_,/}@b);$count=1+shift @arg;$sum+=$count;map { @arg<$_?push @arg,$count:($arg[$_-1]+=$count)}(1..$win);END{say $sum}' "$@" # 11827297 is too high? // Because I counted an extra for the final (empty) line. Discard empties: 11827296
