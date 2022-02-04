-module my_repeater_sup.
-export [test/0].
-export [start/0, repeat/3, stop/0].
-export [init/1].
-behaviour supervisor.
test() ->
    Counter = counters:new(1, []),
    {ok, _} = my_repeater_sup:start(),
    {ok, _} = my_repeater_sup:repeat(fun() -> counters:add(Counter, 1, 1) end, 5, 100),
    {ok, _} = my_repeater_sup:repeat(fun() -> counters:add(Counter, 1, 1) end, 5, 100),
    {ok, _} = my_repeater_sup:repeat(fun() -> counters:add(Counter, 1, 1) end, 5, 100),
    0 = counters:get(Counter, 1),
    ok = timer:sleep(350),
    true = my_repeater_sup:stop(),
    9 = counters:get(Counter, 1),
    ok = timer:sleep(350),
    9 = counters:get(Counter, 1),
    ok.

%%% API -----------------------------------------
start() ->
    supervisor:start_link({local, my_repeater_sup}, my_repeater_sup, noarg).

repeat(Fun, Times, Sleep) ->
    supervisor:start_child(my_repeater_sup, [Fun, Times, Sleep]).

stop() ->
    SupPid = whereis(my_repeater_sup),
    unlink(SupPid),
    exit(SupPid, shutdown).

init(noarg) ->
    {ok,
     {#{strategy => simple_one_for_one},
     [#{id => repeater, start => {my_repeater, repeat, []}}]}}.
