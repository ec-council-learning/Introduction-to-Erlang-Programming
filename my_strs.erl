-module my_strs .
-export [test/0].
-export [encode/1, decode/1].

test() ->
    <<0:2/unit:8>> = my_strs:encode(<<"">>),
    <<"">> = my_strs:decode(<<0:2/unit:8>>),
    <<"a">> = my_strs:decode(<<1:2/unit:8, $a>>),
    <<"a">> = my_strs:decode(<<1:2/unit:8, "abcd">>),
    <<"ab">> = my_strs:decode(<<2:2/unit:8, "abcd">>),
    <<"test">> = my_strs:decode(my_strs:encode(<<"test">>)),
    ok.

encode(<<"">>) ->
    <<0:2/unit:8>>;
encode(String) ->
    L = size(String),
    <<L:2/unit:8, String/binary>>.

decode(<<L:2/unit:8, String:L/bytes, _/bits>>) ->
    String.
