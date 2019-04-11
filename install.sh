#!/usr/bin/env bash

MAX=50
TIME=0.02
TL=""
S="====="
TR=""

function run_command {
    command_name=$1;
    echo $command_name;
    shift;
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "Error: $command_name";
        exit;
    fi
    return $status
}

function run {
    if ! [ -x "$(command -v perl)" ]; then
        echo 'Error: perl is not installed. Cannot install without perl!' >&2
        exit;
    fi
    if ! [ -x "$(command -v cpanm)" ]; then
        echo 'Error: cpanm is not installed. Installing...' >&2
        run_command "Install cpanm" eval "curl -L https://cpanmin.us | perl - --sudo App::cpanminus"
    fi
    run_command "Install modules" eval "cpanm -L . --installdeps . > /dev/null 2>&1"
    eval "rm -rf ./bin";
    run_command "TESTING Check4KnownWords.pl with Australian dictionary" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=au > ./test/au.txt"
    if [[ "$(diff ./test/au.txt ./test/au.expected.txt)" ]]; then
      echo 'Error: Unexpected output from au dictionary check';
    else
      eval "rm -rf ./test/au.txt";
    fi
    run_command "TESTING Check4KnownWords.pl with Canadian dictionary" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=ca > ./test/ca.txt"
    if [[ "$(diff ./test/ca.txt ./test/ca.expected.txt)" ]]; then
      echo 'Error: Unexpected output from ca dictionary check';
    else
      eval "rm -rf ./test/ca.txt";
    fi
    run_command "TESTING Check4KnownWords.pl with British dictionary" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=gb > ./test/gb.txt"
    if [[ "$(diff ./test/gb.txt ./test/gb.expected.txt)" ]]; then
      echo 'Error: Unexpected output from gb dictionary check';
    else
      eval "rm -rf ./test/gb.txt";
    fi
    run_command "TESTING Check4KnownWords.pl with US dictionary" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=us > ./test/us.txt"
    if [[ "$(diff ./test/us.txt ./test/us.expected.txt)" ]]; then
      echo 'Error: Unexpected output from us dictionary check';
    else
      eval "rm -rf ./test/us.txt";
    fi
    run_command "TESTING Check4KnownWords.pl with British-ized dictionary" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=gbize > ./test/gbize.txt"
    if [[ "$(diff ./test/gbize.txt ./test/gbize.expected.txt)" ]]; then
      echo 'Error: Unexpected output from us dictionary check';
    else
      eval "rm -rf ./test/gbize.txt";
    fi
    run_command "TESTING Check4KnownWords.pl with all dictionaries" eval "./Check4KnownWords.pl --file=./test/test.txt --dictionary=au --dictionary=ca --dictionary=gb --dictionary=gbize --dictionary=us > ./test/all.txt"
    if [[ "$(diff ./test/all.txt ./test/all.expected.txt)" ]]; then
      echo 'Error: Unexpected output from all dictionaries check';
    else
      eval "rm -rf ./test/all.txt";
    fi
}

run &
PID=$!

while kill -0 $PID >/dev/null 2>&1; do
    R=0
    while [ $R -lt $MAX ]; do 
        RSP=$(($MAX - $R ))
        if [ $RSP -gt $MAX ]; then RSP=$MAX ; fi 
        LSP=$(($MAX - ${RSP}))
        echo -n "$TL"
        for l in $(seq 1 $LSP); do
            echo -n " "
        done
        echo -n $S
        for r in $(seq 1 $RSP); do
            echo -n " "
        done; echo -ne "$TR\r"
        sleep $TIME ; ((R++))
    done
    while [ $R -ne 0 ]; do
        RSP=$(($MAX - $R ))
        if [ $RSP -ge $MAX ]; then RSP=$MAX ; fi 
        LSP=$(($R + 0 )) 
        if [ $LSP -lt 0 ]; then LSP=0 ; fi 
        echo -n "$TL"
        for l in $(seq 1 $R); do
            echo -n " "
        done
        echo -n $S
        for r in $(seq 1 $RSP); do
            echo -n " "
        done; echo -ne "$TR\r"
        sleep $TIME; ((R--))
    done
done
