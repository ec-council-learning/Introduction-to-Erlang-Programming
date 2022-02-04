-module my_repeater.
-export [test/0].
-export [repeat/3].
-export [init/1, handle_info/2].

test() ->
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

repeat(Fun, Times, Sleep) ->
    gen_server:start_link(my_repeater, #{f => Fun, t => Times, s => Sleep}, []).

init(St = #{s := Sleep}) ->
    {ok, St, Sleep}.

handle_info(timeout, St) ->
    #{f := Fun, t := Times, s := Sleep} = St,
    Fun(),
    case Times of
        1 ->
            {stop, normal, St};
        Times ->
            {noreply, St#{t := Times - 1}, Sleep}
    end.
