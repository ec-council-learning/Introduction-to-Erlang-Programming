-module my_pong.
-export [test/0].
-export [start/1, ping/2, stop/0].
-export [loop/1, sup_loop/1].
test() ->
    ok = my_pong:start(good_key),
    timer:sleep(100),
    pang = my_pong:ping(bad_key, msg_id),
    lists:foreach(fun test/1, lists:seq(1, 11)),
    pang = my_pong:ping(good_key, not_integer),
    timer:sleep(100),
    lists:foreach(fun test/1, lists:seq(1, 11)),
    ok = my_pong:stop().

test(MsgId) ->
    MsgId = my_pong:ping(good_key, MsgId) - 1.

start(GoodKey) ->
    true =
        register(ponger_sup,
            spawn(my_pong, sup_loop, [GoodKey])),
    ok.

ping(Key, MsgId) ->
    ponger ! {ping, MsgId, Key, self()},
    receive {pong, NewMsgId} -> NewMsgId
    after 100 -> pang
    end.

stop() ->
    ponger_sup ! stop,
    ok.

sup_loop(GoodKey) ->
    {Ponger, Monitor} =
        spawn_monitor(my_pong, loop, [GoodKey]),
    true = register(ponger, Ponger),
    receive
        {'DOWN', Monitor, process, Ponger, _} ->
            sup_loop(GoodKey);
        stop ->
            erlang:exit(Ponger, kill)
    end.

loop(GoodKey) ->
    receive
        {ping, MsgId, GoodKey, Caller} ->
            Caller ! {pong, MsgId + 1},
            loop(GoodKey);
        stop ->
            done
    end.
