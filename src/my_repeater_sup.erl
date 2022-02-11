-module my_repeater_sup.
-export [start/0, repeat/3, stop/0].
-export [init/1].
-behaviour supervisor.

%%% API -----------------------------------------
start() ->
    supervisor:start_link({local, my_repeater_sup}, my_repeater_sup, noarg).

repeat(Fun, Times, Sleep) ->
    supervisor:start_child(my_repeater_sup, [Fun, Times, Sleep]).

stop() ->
    gen_server:stop(my_repeater_sup).

init(noarg) ->
    {ok,
     {#{strategy => simple_one_for_one},
     [#{id => repeater, start => {my_repeater, repeat, []}}]}}.
