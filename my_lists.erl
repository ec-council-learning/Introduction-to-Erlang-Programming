-module my_lists.
-export [test/0].
-export [even/1, double/1, half/1].

test() ->
  {L0, L1, L2} = {[], [1], [2, 3]},
  [] = my_lists:even(L0),
  [false] = my_lists:even(L1),
  [true, false] = my_lists:even(L2),
  [] = my_lists:double(L0),
  [2] = my_lists:double(L1),
  [4, 6] = my_lists:double(L2),
  [] = my_lists:half(L0),
  [0.5] = my_lists:half(L1),
  [1.0, 1.5] = my_lists:half(L2),
  ok.

map(_G, []) -> [];
map(G, [H|T]) ->
  [G(H) | map(G, T)].

even(Xs) ->
  map(fun is_even/1, Xs).
is_even(H) -> (H rem 2) == 0.

double(Xs) ->
  map(fun do_double/1,Xs).
do_double(H) -> H * 2.

half(Xs) ->
  map(fun do_half/1, Xs).
do_half(H) -> H/2.
