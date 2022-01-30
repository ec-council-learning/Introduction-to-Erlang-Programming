-module my_server.
-export [start/1, call/2, cast/2, stop/1].

start(Mod) ->
    spawn(Mod, init, []).
call(Server, Msg) ->
    Server ! {call, Msg, self()},
    receive Resp -> Resp end.
cast(Server, Msg) ->
    Server ! {cast, Msg}, ok.
stop(Server) -> Server ! stop, ok.
