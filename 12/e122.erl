-module(e122).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, nil).

init(_Args) ->
    {ok, {{one_for_one, 5, 3600},
         [{e121,
           {e121, start_link, []},
           permanent, 30000, worker, [e121]}]}}.
