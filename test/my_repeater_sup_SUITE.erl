-module my_repeater_sup_SUITE.
-export [test/1, all/0].
-behaviour ct_suite.
all() -> [test].
test(_) ->
    Counter = counters:new(1, []),
    Add1 = fun() -> counters:add(Counter, 1, 1) end,
    {ok, _} = my_repeater_sup:start(),
    {ok, _} = my_repeater_sup:repeat(Add1, 5, 100),
    {ok, _} = my_repeater_sup:repeat(Add1, 5, 100),
    {ok, _} = my_repeater_sup:repeat(Add1, 5, 100),
    0 = counters:get(Counter, 1),
    ok = timer:sleep(350),
    ok = my_repeater_sup:stop(),
    9 = counters:get(Counter, 1),
    ok = timer:sleep(350),
    9 = counters:get(Counter, 1),
    ok.
