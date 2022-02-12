%%% @doc Repeats a task multiple times at regular intervals
-module(my_repeater).

-export([repeat/3]).
-export([init/1, handle_info/2]).

%% @doc Repeats <code>Fun</code> <code>Times</code>
%%      times, sleeping <code>Sleep</code>
%%      milliseconds between each run
repeat(Fun, Times, Sleep) ->
    gen_server:start_link(my_repeater,
                          #{f => Fun,
                            t => Times,
                            s => Sleep},
                          []).

%% @private
init(St = #{s := Sleep}) ->
    {ok, St, Sleep}.

%% @private
handle_info(timeout, St) ->
    #{f := Fun,
      t := Times,
      s := Sleep} =
        St,
    Fun(),
    case Times of
        1 ->
            {stop, normal, St};
        Times ->
            {noreply, St#{t := Times - 1}, Sleep}
    end.
