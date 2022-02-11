-module my_repeater_SUITE.
-export [test/1, all/0].
-behaviour ct_suite.
all() -> [test].
test(_) ->
    Counter = counters:new(1, []),
    0 = counters:get(Counter, 1),
    {ok, Rep1} = my_repeater:repeat(fun() -> counters:add(Counter, 1, 1) end, 5, 100),
    0 = counters:get(Counter, 1),
    ok = timer:sleep(600),
    5 = counters:get(Counter, 1),
    false = erlang:is_process_alive(Rep1),

    Self = self(),
    {ok, Rep2} = my_repeater:repeat(
        fun() ->
            Self ! {self(), counters:get(Counter, 1)},
            counters:sub(Counter, 1, 1)
        end, 5, 90),
    [receive {Rep2, I} -> ok after 100 -> error({timeout, I}) end || I <- [5,4,3,2,1]],
    false = erlang:is_process_alive(Rep2),
    ok.
