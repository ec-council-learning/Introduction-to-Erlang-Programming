-module my_app.
-export [start/2, stop/1].
-behaviour application.

start(_, noarg) -> my_sup:start().

stop(_) -> ok.
