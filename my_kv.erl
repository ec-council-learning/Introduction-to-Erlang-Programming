-module my_kv.
-export [test/0].
-export [start/0, get/2, set/3, stop/1].
-export [init/0, handle_call/2, handle_cast/2].

%%% TEST ----------------------------------------
test() ->
    KV = my_kv:start(),
    not_found = my_kv:get(a, KV),
    ok = my_kv:set(a, 1, KV),
    1 = my_kv:get(a, KV),
    ok = my_kv:set(a, 2, KV),
    2 = my_kv:get(a, KV),
    not_found = my_kv:get(b, KV),
    ok = my_kv:stop(KV).

%%% API -----------------------------------------
start() ->
    my_server:start(my_kv).
get(Key, KV) ->
    my_server:call(KV, {get, Key}).
set(Key, Value, KV) ->
    my_server:cast(KV, {set, Key, Value}).
stop(KV) -> my_server:stop(KV).

init() -> #{}.

handle_call({get, K}, St) ->
    {maps:get(K, St, not_found), St}.

handle_cast({set, K, V}, St) ->
    St#{K => V}.
