-module(etick_util).
-export([default_machine/0]).
-export([encode_id/1, decode_id/1]).

-include("etick.hrl").

default_machine() ->
    erlang:phash2(os:timestamp(), 1 bsl ?BIT_SIZE_MACHINE).

encode_id(#id{timestamp = Timestamp, 
              sequence = Sequence, 
              machine = Machine, 
              class = Class}) ->
    <<Id:?BIT_SIZE_ID>> = <<Timestamp:?BIT_SIZE_TIMESTAMP, 
                            Sequence:?BIT_SIZE_SEQUENCE, 
                            Machine:?BIT_SIZE_MACHINE, 
                            Class:?BIT_SIZE_CLASS>>,
    Id.

decode_id(Id) ->
    <<Timestamp:?BIT_SIZE_TIMESTAMP, 
      Sequence:?BIT_SIZE_SEQUENCE, 
      Machine:?BIT_SIZE_MACHINE, 
      Class:?BIT_SIZE_CLASS>> = <<Id:?BIT_SIZE_ID>>,
    #id{timestamp=Timestamp, sequence=Sequence, machine=Machine, class=Class}.
