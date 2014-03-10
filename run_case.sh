#!/bin/sh

cur_dir=`pwd`
input_home=/home/joerong/test/sed
input=$1
suite_home="case"

suite=$2

cd $input_home && ./gen_case.sh $input

cd $cur_dir

cat <<IN >$suite_home/${suite}.txt
*** Setting ***
Library     ../model/${suite}.py
Variables   ../resource/var.py

*** Variable ***
\${proxy_addr}   localhost:32000

*** Test Case ***
IN

cat $input_home/case.out >>$suite_home/${suite}.txt

pybot -v proxy_addr:localhost:32000 -s ${suite_home}.${suite} -i *check* -d ../log -L DEBUG .
#pybot -s ${suite_home}.${suite} -t case_23 -d ../log -L DEBUG .
#    [ $? -eq 0 ] && rm $suite_home/${target_suite}.txt
