-module my_kv_sup.
-export [test/0].
-export [start/0, kv/0, stop/0].
-export [init/1].
-behaviour supervisor.

%%% TEST ----------------------------------------
test() ->
    {ok, _} = my_kv_sup:start(),
    KV = my_kv_sup:kv(),
    ok = my_kv:set(a, 1, KV),
    1 = my_kv:get(a, KV),
    exit(KV, kill),
    timer:sleep(100),
    KV2 = my_kv_sup:kv(),
    false = KV == KV2,
    not_found = my_kv:get(a, KV2),
    true = my_kv_sup:stop(),
    ok.

%%% API -----------------------------------------
start() ->
    supervisor:start_link({local, my_kv_sup}, my_kv_sup, noarg).

kv() ->
    [KV] = [KVPid || {kv, KVPid, worker, [my_kv]} <- supervisor:which_children(my_kv_sup)],
    KV.

stop() ->
    SupPid = whereis(my_kv_sup),
    unlink(SupPid),
    exit(SupPid, shutdown).

init(noarg) ->
    {ok, {#{}, [#{id => kv, start => {my_kv, start, []}}]}}.
