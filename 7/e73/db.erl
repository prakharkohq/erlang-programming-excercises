-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).
-export([test/0]).
-include("db.hrl").

new() -> [].

destroy(Db) when is_list(Db) -> ok.

write(K, V, Db) -> [#data{key=K, data=V}|delete(K, Db)].

delete(_, []) -> [];
delete(K, [#data{key=K}|Rest]) -> Rest;
delete(K, [H|Rest]) -> [H|delete(K, Rest)].

read(_, []) -> {error, instance};
read(K, [#data{key=K, data=V}|_]) -> {ok, V};
read(K, [_|Rest]) -> read(K, Rest).

match(_, []) -> [];
match(V, [#data{key=K, data=V}|Rest]) -> [K|match(V, Rest)];
match(V, [_|Rest]) -> match(V, Rest).

test() ->
  [] = Db = new(),
  [#data{key=francesco, data=london}] = Db1 = write(francesco, london, Db),
  [#data{key=lelle, data=stockholm},
   #data{key=francesco, data=london}] = Db2 = write(lelle, stockholm, Db1),
  {ok,london} = read(francesco, Db2),
  [#data{key=joern, data=stockholm},
   #data{key=lelle, data=stockholm},
   #data{key=francesco, data=london}] = Db3 = write(joern, stockholm, Db2),
  {error,instance}= read(ola, Db3),
  [joern,lelle] = match(stockholm, Db3),
  [#data{key=joern, data=stockholm},
   #data{key=francesco, data=london}] = Db4 = delete(lelle, Db3),
  [#data{key=francesco, data=prague},
   #data{key=joern, data=stockholm}] = write(francesco, prague, Db4),
  [joern] = match(stockholm, Db4),
  ok.
