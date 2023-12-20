perl -nE '$sum+= join q//, (/(\d)/g)[0,-1]; END{say $sum}'  input
perl -nE 'BEGIN{$n="one|two|three|four|five|six|seven|eight|nine";@n{split/\|/,$n}=(1..9);} 1 while (s/($n)/$n{$1}.substr($1,-1)/e); $sum+= join q//, (m/(\d)/g)[0,-1]; END{say $sum}' input
# ^^ Had to include the last character of each alphadigit so that sevenine is 79 instead of 7ine. FFS.
