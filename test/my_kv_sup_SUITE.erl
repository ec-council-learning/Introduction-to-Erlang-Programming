-module(my_kv_sup_SUITE).

-export([test/1, all/0]).

-behaviour(ct_suite).

all() ->
    [test].

test(_) ->
    {ok, _} = my_kv_sup:start(),
    KV = my_kv_sup:kv(),
    ok = my_kv:set(a, 1, KV),
    1 = my_kv:get(a, KV),
    exit(KV, kill),
    timer:sleep(100),
    KV2 = my_kv_sup:kv(),
    false = KV == KV2,
    not_found = my_kv:get(a, KV2),
    ok = my_kv_sup:stop(),
    ok.
