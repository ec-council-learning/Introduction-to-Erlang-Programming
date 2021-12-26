-module my_mod.
-export [err/0, raise/0, exit/0].
-export [min/1, test/0].

%% Required for min/2
-compile({no_auto_import,[min/2]}).

err() -> 1 / 0.

raise() ->
  erlang:raise(
    error, my_reason,
    [{my_mod, my_fun, 1, [my_arg]}]).

exit() ->
  erlang:exit(my_reason).

test() ->
  LongRow = lists:seq(0, 100000),
  LargeMatrix = lists:duplicate(10000, LongRow),
  {T, 0} = timer:tc(my_mod, min, [LargeMatrix]),
  {ok, T}.

min([Row|Rows]) -> catch min(row_min(Row), Rows).
min(Min, []) -> Min;
min(Min, [Row|Rows]) ->
  case row_min(Row) of
    NewMin when NewMin < Min -> min(NewMin, Rows);
    _ -> min(Min, Rows)
  end.

row_min([H|T]) -> row_min(H, T).
row_min(0, _) -> throw(0);
row_min(Min, []) -> Min;
row_min(Min, [H|T]) when H < Min -> row_min(H, T);
row_min(Min, [_|T]) -> row_min(Min, T).
