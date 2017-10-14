-module(e36).
-export([quicksort/1, mergesort/1]).

quicksort([]) -> [];
quicksort([Pivot|T]) ->
    [Smaller, Larger] = split(Pivot, T, [], []),
    quicksort(Smaller) ++ [Pivot|quicksort(Larger)].

split(Pivot, [H|T], Smaller, Larger) when H < Pivot ->
    split(Pivot, T, [H|Smaller], Larger);
split(Pivot, [H|T], Smaller, Larger) ->
    split(Pivot, T, Smaller, [H|Larger]);
split(_, [], Smaller, Larger) -> [Smaller, Larger].


mergesort([]) -> [];
mergesort([E]) -> [E];
mergesort(L) ->
    {A, B} = lists:split(trunc(length(L)/2), L),
    merge(mergesort(A), mergesort(B)).

merge(A, []) -> A;
merge([], B) -> B;
merge([Ha|Ta], [Hb|_]=B) when Ha < Hb ->
    [Ha|merge(Ta, B)];
merge(A, [Hb|Tb]) ->
    [Hb|merge(Tb, A)].
