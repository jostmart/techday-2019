#!/bin/bash

grn=$'\e[1;32m'
blu=$'\e[1;34m'
blink=$'\e[1;5m'
end=$'\e[0m'

foo=`cat commands.sh`
comm=''

pwd=`pwd`

printf "${grn}cygate@ubuntuV1${end}:${blu}~${pwd#*/home/cygate}${end}\$ "

for (( i=0; i<${#foo}; i++ )); do
  read -rsn1 input
  if [ "${foo:$i:1}" = $'\n' ]; then
    while [[ $input != "" ]]; do
      read -rsn1 input
    done
    comm+=$'\n'
    printf $'\n'
    eval $comm
    comm=''
printf "${grn}cygate@ubuntuV1${end}:${blu}~${pwd#*/home/cygate}${end}\$ "
  else
    comm+="${foo:$i:1}"
    printf "${foo:$i:1}"
  fi
done
while [[ $input != "" ]]; do
  read -rsn1 input
done
printf $'\n'
comm+=$'\n'
eval $comm