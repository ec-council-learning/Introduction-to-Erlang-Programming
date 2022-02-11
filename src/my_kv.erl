-module my_kv.
-export [start/0, get/2, set/3, stop/1].
-export [init/1, handle_call/3, handle_cast/2].

-behaviour gen_server.

%%% API -----------------------------------------
start() ->
    gen_server:start_link(my_kv, noarg, []).
get(Key, KV) ->
    gen_server:call(KV, {get, Key}).
set(Key, Value, KV) ->
    gen_server:cast(KV, {set, Key, Value}).
stop(KV) -> gen_server:stop(KV).

init(noarg) -> {ok, #{}}.

handle_call({get, K}, _From, St) ->
    {reply, maps:get(K, St, not_found), St}.

handle_cast({set, K, V}, St) ->
    {noreply, St#{K => V}}.
