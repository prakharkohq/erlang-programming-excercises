-module(e41).
-export([start/0, print/1, stop/0]).

start() ->
    Pid = spawn(fun() -> loop() end),
    register(?MODULE, Pid).

stop() ->
    ?MODULE ! stop,
    ok.

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
