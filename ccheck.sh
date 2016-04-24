#!/bin/bash

index=1
tests=$(($#-1))
pass=0
fail=0
template=$1

printf "TAP version 13\n1..$tests\n"

for ver in "${@:2}"
do
  uuid=$(uuidgen -t)

  mkdir "/tmp/$uuid"
  cp * "/tmp/$uuid/."
  cd "/tmp/$uuid" 

  # modify version information
  sed "1s/\$VERSION/$ver/" "$template" > Dockerfile

  # build a docker container based on the Dockerfile
  docker build -t="$uuid" . >/dev/null

  # can't build docker container
  if [[ $? -eq 1 ]]; then
    printf "not ok $index - fail building ver. $ver\n"
    let fail++
  else
    # run and remove container after it finish running
    docker run --rm $uuid >/dev/null 2>error.log

    if [[ -s error.log ]]; then
      printf "not ok $index - ver. $ver\n"
      printf " ---\n"
      cat error.log | sed -e 's/^/\t/'
      printf "\n ...\n"
      let fail++
    else
      printf "ok $index - ver. $ver\n"
      let pass++
    fi
    # remove the image
    docker rmi "$uuid" > /dev/null 2>&1 
  fi

  let index++

  # remove temporary folder
  rm -fr "/tmp/$uuid" > /dev/null 2>&1

  cd - > /dev/null
done

printf "\n#tests $tests\n"
printf "#pass  $pass\n"
printf "#fail  $fail\n"
