-module(e51).
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).

start() ->
    Pid = spawn(fun() -> loop([]) end),
    register(?MODULE, Pid),
    ok.

stop() ->
    ?MODULE ! stop,
    ok.

write(K, V) ->
    ?MODULE ! {write, K, V},
    ok.

delete(K) ->
    ?MODULE ! {delete, K},
    ok.

read(K) ->
    ?MODULE ! {read, K, self()},
    receive
        {read, K, false} -> {error, instance};
	{read, K, {K, V}} -> {ok, V}
    end.

match(V) ->
    ?MODULE ! {match, V, self()},
    receive
	{match, V, R} -> lists:map(fun({K, _}) -> K end, R)
    end.

loop(Db) ->
    receive
        stop -> ok;
	{write, K, V} -> loop(lists:keystore(K, 1, Db, {K, V}));
	{delete, K} -> loop(lists:keydelete(K, 1, Db));
	{read, K, From} ->
	    From ! {read, K, lists:keyfind(K, 1, Db)},
	    loop(Db);
	{match, V, From} ->
	    From ! {match, V, lists:filter(fun({_, Val}) -> Val == V end, Db)},
	    loop(Db)
    end.
