-module(e121).
-export([start_link/0, start_link/1]).
-export([init/1, terminate/2, handle_call/3, handle_cast/2]).
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
-behavioir(gen_server).

%% API for maintenance

start_link() ->
    start_link([]).

start_link(Db) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Db, []).

%% Client Functions

start() ->
    start_link(), ok.

stop() ->
    gen_server:cast(?MODULE, stop), ok.

write(K, V) ->
    gen_server:cast(?MODULE, {write, K, V}), ok.

delete(K) ->
    gen_server:cast(?MODULE, {delete, K}), ok.

read(K) ->
    gen_server:call(?MODULE, {read, K}).

match(V) ->
    gen_server:call(?MODULE, {match, V}).


%% Callback Functions

init(_Args) -> {ok, []}.

terminate(_Reason, _Db) -> ok.

handle_cast(stop, Db) ->
    {stop, normal, Db};

handle_cast({write, K, V}, Db) ->
    {noreply, lists:keystore(K, 1, Db, {K, V})};

handle_cast({delete, K}, Db) ->
    {noreply, lists:keydelete(K, 1, Db)}.

handle_call({read, K}, _From, Db) ->
    case lists:keyfind(K, 1, Db) of
	{K, V} -> {reply, {ok, V}, Db};
	false  -> {reply, {error, instance}, Db}
    end;

handle_call({match, V}, _From, Db) ->
    Matched = lists:filter(fun({_, Val}) -> Val == V end, Db),
    Keys = lists:map(fun({K, _}) -> K end, Matched),
    {reply, Keys, Db}.
