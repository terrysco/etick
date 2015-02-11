#!/bin/sh
# NOTE: mustache templates need \ because they are not awesome.
#HOST=`ifconfig eth1 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1`
CMD="erl -pa ebin ./deps/*/ebin  \
    +K true -smp +S 8 +P 2000000 \
    -setcookie etick \
    -boot start_sasl \
    -name etick@127.0.0.1\
    -s lager \
    -s etick_app \
    -config etick"
echo $CMD
exec $CMD
#RUN_ERL_LOG_MAXSIZE=100000000
#export RUN_ERL_LOG_MAXSIZE
#run_erl -daemon /tmp/ ./logs "exec $CMD"
