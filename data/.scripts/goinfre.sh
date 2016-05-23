#! /bin/sh
# Script from http://superuser.com/a/529800


if ( [ "$1" != '' ] )
then
	DIR=$1
else
	DIR='/'
fi

printf "Scanning dir $DIR\n"
t=$(df|awk 'NR!=1{sum+=$2}END{print sum}');2>&1 du $DIR –-exclude /proc –-exclude /sys –-max-depth=1|sed '$d'|sort -rn -k1 | awk -v t=$t 'OFMT="%d" {M=64; for (a=0;a<$1;a++){if (a>c){c=a}}br=a/c;b=M*br;for(x=0;x<b;x++) {printf "\033[1;31m" "|" "\033[0m"}print " "$2" "(a/t*100)"% total"}'
