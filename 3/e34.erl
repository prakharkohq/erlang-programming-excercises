-module(e34).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).
-export([test/0]).

new() -> [].

destroy(Db) when is_list(Db) -> ok.

write(K, V, Db) -> [{K, V}|delete(K, Db)].

delete(_, []) -> [];
delete(K, [{K, _}|Rest]) -> Rest;
delete(K, [H|Rest]) -> [H|delete(K, Rest)].

read(_, []) -> {error, instance};
read(K, [{K, V}|_]) -> {ok, V};
read(K, [_|Rest]) -> read(K, Rest).

match(_, []) -> [];
match(V, [{K, V}|Rest]) -> [K|match(V, Rest)];
match(V, [_|Rest]) -> match(V, Rest).

test() ->
  [] = Db = new(),
  [{francesco,london}] = Db1 = write(francesco, london, Db),
  [{lelle,stockholm},{francesco,london}] = Db2 = write(lelle, stockholm, Db1),
  {ok,london} = read(francesco, Db2),
  [{joern,stockholm},{lelle,stockholm},{francesco,london}] = Db3 = write(joern, stockholm, Db2),
  {error,instance}= read(ola, Db3),
  [joern,lelle] = match(stockholm, Db3),
  [{joern,stockholm},{francesco,london}] = Db4 = delete(lelle, Db3),
  [{francesco,prague},{joern,stockholm}] = write(francesco, prague, Db4),
  [joern] = match(stockholm, Db4),
  ok.
