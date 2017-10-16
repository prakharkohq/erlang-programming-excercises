-module(e54).
-export([init/1, terminate/1, handle_event/2]).

init(Stats) -> Stats.

terminate(Stats) -> {stats, Stats}.

handle_event({Type, _, Description}, Stats) ->
  Key = {Type, Description},
  case lists:keyfind(Key, 1, Stats) of
    {K, V} -> lists:keystore(K, 1, Stats, {K, V+1});
    false -> [{Key, 1}|Stats]
  end;
handle_event(_, Stats) ->
  Stats.
