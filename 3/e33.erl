-module(e33).
-export([print/1, print_even/1]).

print(Max) -> print(1, Max, 1).

print_even(Max) -> print(2, Max, 2).

print(C, Max, _) when C > Max -> ok;
print(C, Max, Step) ->
    io:format("Number: ~p~n", [C]),
    print(C+Step, Max, Step).
