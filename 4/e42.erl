-module(e42).
-export([start/3]).

start(M, N, Msg) when N > 0 ->
    Last = spawn(fun() -> receive P when is_pid(P) -> loop(P) end end),
    Last ! spawn_node(N-1, Last),
    [Last ! {msg, Msg} || _ <- lists:seq(1, M)],
    Last ! quit.

spawn_node(0, Pid) -> Pid;
spawn_node(N, Pid) ->
    This = spawn(fun() -> loop(Pid) end),
    spawn_node(N-1, This).

loop(Next) ->
    receive
	quit -> Next ! quit;
	{msg, _} = Msg ->
	    io:format("~p -> ~p~n", [self(), Next]),
	    Next ! Msg,
	    loop(Next)
    end.
