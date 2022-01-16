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

even(Xs) -> [(X rem 2) == 0 || X <- Xs].

double(Xs) -> [X * 2 || X <- Xs].

half(Xs) -> [X / 2 || X <- Xs].
