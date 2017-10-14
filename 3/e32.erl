-module(e32).
-export([create/1, reverse_create/1]).

create(N) when is_integer(N), N >= 0 -> create(N, []).

create(0, Acc) -> Acc;
create(N, Acc) -> create(N-1, [N|Acc]).

reverse_create(N) -> reverse(create(N), []).

reverse([], Acc) -> Acc;
reverse([H|R], Acc) -> reverse(R, [H|Acc]).
