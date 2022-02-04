-module my_sup.
-export [start/0].
-export [init/1].
-behaviour supervisor.

start() ->
    supervisor:start_link({local, my_sup}, my_sup, noarg).

init(noarg) ->
    {ok,
     {#{strategy => one_for_one},
     [#{id => repeater_sup, start => {my_repeater_sup, start, []}, type => supervisor},
      #{id => kv_sup, start => {my_kv_sup, start, []}, type => supervisor}]}}.
