-module(my_kv_sup).

-export([start/0, kv/0, stop/0]).
-export([init/1]).

-behaviour(supervisor).

%%% API -----------------------------------------
start() ->
    supervisor:start_link({local, my_kv_sup}, my_kv_sup, noarg).

kv() ->
    [{kv, KV, worker, [my_kv]}] = supervisor:which_children(my_kv_sup),
    KV.

stop() ->
    gen_server:stop(my_kv_sup).

%%% CALLBACKS -----------------------------------
init(noarg) ->
    {ok, {#{}, [#{id => kv, start => {my_kv, start, []}}]}}.
