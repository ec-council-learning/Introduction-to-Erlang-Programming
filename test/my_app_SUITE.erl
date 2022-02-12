-module(my_app_SUITE).

-export([test/1, all/0]).

-behaviour(ct_suite).

all() ->
    [test].

test(_) ->
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
