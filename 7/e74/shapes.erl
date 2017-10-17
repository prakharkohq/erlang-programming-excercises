-module(shapes).
-export([perimeter/1, area/1]).
-include("shapes.hrl").

perimeter(#circle{radius=R}) ->
    R * 2 * math:pi();
perimeter(#triangle{a=A, b=B, c=C}) ->
    A + B + C;
perimeter(#rectangle{width=W, height=H}) ->
    2 * W + 2 * H.

area(#circle{radius=R}) ->
    R * R * math:pi();
area(#triangle{a=A, b=B, c=C}=T) ->
    P = 0.5 * perimeter(T),
    math:sqrt(P * (P - A) * (P - B) * (P - C));
area(#rectangle{width=W, height=H}) ->
    W * H.
