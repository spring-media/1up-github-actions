#!/usr/bin/env bash

input="$1"
paths=(${input})
echo "size=${#paVths[@]} 0=${paths[0]} 1=${paths[1]} 2=${paths[2]}"

filter_paths=""
for ((i = 0; i < ${#paths[@]}; i++)); do
  filter_paths+="\"${paths[$i]}/**\","
done
length=${#filter_paths}
echo "[ ${filter_paths:0: length - 1} ]"
