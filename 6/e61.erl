-module(e61).
-export([start/0, print/1, stop/0]).

start() ->
    Pid = spawn_link(fun() -> loop() end),
    register(?MODULE, Pid).

stop() -> 1/0.

print(Term) ->
    ?MODULE ! {msg, Term},
    ok.

loop() ->
    receive
        stop -> ok;
	{msg, Term} ->
            io:format("~p~n", [Term]),
            loop();
	Msg ->
	    io:format("Unexpected message ~p", [Msg]),
	    loop()
    end.
