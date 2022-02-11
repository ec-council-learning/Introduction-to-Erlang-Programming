-module my_app.
-export [test/0].
-export [start/2, stop/1].
-behaviour application.

test() ->
    {ok, [my_app]} = application:ensure_all_started(my_app),

    Counter = counters:new(1, []),
    {ok, _} = my_repeater_sup:repeat(fun() -> counters:add(Counter, 1, 1) end, 5, 100),
    0 = counters:get(Counter, 1),
    ok = timer:sleep(150),
    1 = counters:get(Counter, 1),

    KV = my_kv_sup:kv(),
    not_found = my_kv:get(a, KV),

    ok = application:stop(my_app),
    undefined = whereis(my_repeater_sup),
    undefined = whereis(my_kv_sup),
    ok.

start(_, noarg) -> my_sup:start().

stop(_) -> ok.
