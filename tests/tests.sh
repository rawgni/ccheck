#!/bin/bash 

TESTS=2
PASS=0
FAIL=0

ARR=(node perl)

printf "TAP version 13\n1..$TESTS\n"

for i in ${!ARR[@]}; do
	
	(cd "../examples/${ARR[i]}"; ./run.sh) | diff "${ARR[i]}.expected" - >/dev/null
	if [[ $? -eq 0 ]]; then
		printf "ok $((i+1))\n"
		let PASS++
	else
		printf "not ok $((i+1))\n"
		let FAIL++
	fi
done

printf "\n"
printf "#tests $TESTS\n"
printf "#pass $PASS\n"
printf "#fail $FAIL\n"
