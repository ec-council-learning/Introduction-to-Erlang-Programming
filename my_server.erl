-module my_server.
-export [start/1, call/2, cast/2, stop/1].
-export [init/1].

start(Mod) ->
    spawn(my_server, init, [Mod]).
call(Server, Msg) ->
    Server ! {call, Msg, self()},
    receive Resp -> Resp end.
cast(Server, Msg) ->
    Server ! {cast, Msg}, ok.
stop(Server) -> Server ! stop, ok.

init(Mod) ->
    loop(Mod, Mod:init()).

loop(Mod, St) ->
  receive
    {call, Msg, C} ->
        {Res, NewSt}
            = Mod:handle_call(Msg, St),
        C ! Res,
        loop(Mod, NewSt);
    {cast, Msg} ->
        NewSt = Mod:handle_cast(Msg, St),
        loop(Mod, NewSt);
    stop -> done
  end.
