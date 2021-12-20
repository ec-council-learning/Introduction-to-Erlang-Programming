-module my_kv.
-export [test/0].
-export [start/0, get/2, set/3, stop/1].
-export [init/0].

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
    spawn(my_kv, init, []).

get(Key, KV) ->
    KV ! {get, Key, self()},
    receive
        Value -> Value
    end.

set(Key, Value, KV) ->
    KV ! {set, Key, Value},
    ok.

stop(KV) ->
    KV ! stop,
    ok.

%%% SERVER --------------------------------------
init() ->
    InitialState = #{},
    loop(InitialState).

loop(State) ->
  receive
    {get, Key, Caller} ->
        Caller ! maps:get(Key, State, not_found),
        loop(State);
    {set, Key, Value} ->
        loop(State#{Key => Value});
    stop -> done
  end.