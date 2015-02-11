-define(TIMER_UPDATE_INTERVAL, 1000).
-define(MAX_IDS_PER_REQUEST, 100).
-define(DEFAULT_CLASS_TYPE, 0).

%% time 30 bits
-define(BIT_SIZE_TIMESTAMP, 30).
%% sequence 15 bits
-define(BIT_SIZE_SEQUENCE,  15).
%% machine 10 bits
-define(BIT_SIZE_MACHINE,   10).
%% class 2 bits
-define(BIT_SIZE_CLASS,      2).

-define(BIT_SIZE_ID, (?BIT_SIZE_TIMESTAMP+?BIT_SIZE_SEQUENCE+
                      ?BIT_SIZE_MACHINE+?BIT_SIZE_CLASS)).

-record(id, {timestamp, 
             sequence, 
             machine, 
             class}). 
