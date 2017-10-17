-module(e75).
-export([node/3, leaf/1, sum/1, max/1, ordered/1, insert/2]).

-record(btree, {l=nil, r=nil, value}).

leaf(V) -> #btree{value=V}.
node(L, R, V) -> #btree{l=L, r=R, value=V}.

sum(nil) -> 0;
sum(#btree{l=L, r=R, value=V}) ->
    V + sum(L) + sum(R).

max(nil) -> nil;
max(#btree{l=L, r=R, value=V}) ->
    Vals = [V, max(L), max(R)],
    lists:max(lists:filter(fun erlang:is_number/1, Vals)).

ordered(#btree{l=nil, r=nil}) -> true;
ordered(#btree{l=nil, r=#btree{value=RV}=R, value=V}) ->
    RV >= V andalso ordered(R);
ordered(#btree{r=nil, l=#btree{value=LV}=L, value=V}) ->
    LV =< V andalso ordered(L);
ordered(#btree{l=#btree{value=LV}=L, r=#btree{value=RV}=R, value=V}) ->
    RV >= V andalso LV =< V andalso ordered(L) andalso ordered(R).


insert(nil, NewV) -> leaf(NewV);
insert(#btree{l=L, value=V}=T, NewV) when NewV < V ->
    T#btree{l=insert(L, NewV)};
insert(#btree{r=R}=T, NewV) ->
    T#btree{r=insert(R, NewV)}.
