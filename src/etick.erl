-module(etick).
-behaviour(gen_server).

%% API functions
-export([start_link/1, id/0, id/1, ids/1, ids/2, count/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(state, {count, 
                timestamp,
                sequence,
                machine}).

-define(SERVER, ?MODULE).
-include("etick.hrl").

start_link(Machine) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [Machine], []).

init([Machine]) ->
    timer:send_after(?TIMER_UPDATE_INTERVAL, timer_update),
    {ok, #state{count=0, timestamp=get_unix_time(), sequence=1, machine=Machine}}.

get_unix_time() ->
    {M, S, _} = os:timestamp(),
    M * 1000000 + S.

count() ->
    gen_server:call(?SERVER, count).

id() ->
    id(?DEFAULT_CLASS_TYPE).
id(Class) when is_integer(Class) ->
    gen_server:call(?SERVER, {id, Class});
id(_) ->
    lager:error("invalid class type.").

ids(N) ->
    ids(N, ?DEFAULT_CLASS_TYPE).

ids(N, Class) when is_integer(N), N > ?MAX_IDS_PER_REQUEST ->
    ids(?MAX_IDS_PER_REQUEST, Class);
ids(N, Class) when is_integer(N) ->
    gen_server:call(?SERVER, {ids, N, Class});
ids(_, _) ->
    lager:error("invalid class type").

handle_call({id, Class}, _From, State=#state{timestamp=Timestamp, 
                                    count=Count, 
                                    sequence=Sequence, 
                                    machine=Machine}) ->
    Id = etick_util:encode_id(#id{timestamp = Timestamp, 
                                  sequence = Sequence, 
                                  machine  = Machine, 
                                  class = Class}),
    {reply, Id, State#state{count=Count+1, sequence=Sequence+1}};

handle_call({ids, N, Class}, _From, State=#state{timestamp=Timestamp, 
                                          count=Count, 
                                          sequence=Sequence, 
                                          machine=Machine}) ->
    Ids = [etick_util:encode_id(#id{timestamp = Timestamp, 
                                    sequence = Sequence + Incr - 1, 
                                    machine = Machine, 
                                    class = Class}) 
           || Incr <- lists:seq(1, N)],
    {reply, Ids, State#state{count=Count+N, sequence=Sequence+N}};

handle_call(count, _From, State=#state{count=Count}) ->
    {reply, Count, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timer_update, State) ->
    timer:send_after(?TIMER_UPDATE_INTERVAL, timer_update),
    {noreply, State#state{timestamp=get_unix_time(), sequence=1}};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
