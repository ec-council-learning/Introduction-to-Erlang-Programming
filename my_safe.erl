-module my_safe.
-export [test/0].
-export [new/0, out/2, in/3, destroy/1].
-export [init/0].

%%% TEST ----------------------------------------
test() ->
    Safe = my_safe:new(),
    {error, empty} = my_safe:out(a_key, Safe),
    ok = my_safe:in(good_key, secret, Safe),
    {error, full} =
        my_safe:in(bad_key, secret, Safe),
    {error, full} =
        my_safe:in(good_key, another_secret, Safe),
    {error, badkey} = my_safe:out(bad_key, Safe),
    {ok, secret} = my_safe:out(good_key, Safe),
    {error, empty} = my_safe:out(good_key, Safe),
    ok = my_safe:destroy(Safe).

%%% API -----------------------------------------
new() -> spawn(my_safe, init, []).

out(Key, Safe) ->
    Safe ! {out, Key, self()},
    receive
        Response -> Response
    end.

in(Key, Secret, Safe) ->
    Safe ! {in, Key, Secret, self()},
    receive
        Response -> Response
    end.

destroy(Safe) ->
    Safe ! stop,
    ok.

%%% SERVER --------------------------------------
init() -> unlocked().

unlocked() ->
    receive
        {out, _Key, Caller} ->
            Caller ! {error, empty},
            unlocked();
        {in, Key, Secret, Caller} ->
            Caller ! ok,
            locked(Key, Secret);
        stop -> done
    end.

locked(GoodKey, Secret) ->
    receive
        {out, GoodKey, Caller} ->
            Caller ! {ok, Secret},
            unlocked();
        {out, _BadKey, Caller} ->
            Caller ! {error, badkey},
            locked(GoodKey, Secret);
        {in, _Key, _Secret, Caller} ->
            Caller ! {error, full},
            locked(GoodKey, Secret);
        stop -> done
    end.
