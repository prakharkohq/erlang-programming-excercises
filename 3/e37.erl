-module(e37).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).
-export([test/0]).

new() -> [].

destroy(Db) when is_list(Db) -> ok.

write(K, V, Db) -> lists:keystore(K, 1, Db, {K, V}).

delete(K, Db) -> lists:keydelete(K, 1, Db).

read(K, Db) -> read(lists:keyfind(K, 1, Db)).
read(false) -> {error, instance};
read({_, V}) -> {ok, V}.

match(V, Db) ->
    R = lists:filter(fun({_, Val}) -> Val == V end, Db),
    lists:map(fun({K, _}) -> K end, R).

test() ->
  [] = Db = new(),
  [{francesco,london}] = Db1 = write(francesco, london, Db),
  [{francesco,london},{lelle,stockholm}] = Db2 = write(lelle, stockholm, Db1),
  {ok,london} = read(francesco, Db2),
  [{francesco,london},{lelle,stockholm},{joern,stockholm}] = Db3 = write(joern, stockholm, Db2),
  {error,instance}= read(ola, Db3),
  [lelle,joern] = match(stockholm, Db3),
  [{francesco,london},{joern,stockholm}] = Db4 = delete(lelle, Db3),
  [{francesco,prague},{joern,stockholm}] = write(francesco, prague, Db4),
  [joern] = match(stockholm, Db4),
  ok.
