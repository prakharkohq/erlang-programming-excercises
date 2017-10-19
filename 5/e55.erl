-module(e55).
-export([turn_on/0, turn_off/1]).

turn_on() ->
  e53:start(phone, []),
  spawn(fun() -> idle() end).

turn_off(Phone) ->
  Phone ! {turn_off, self()},
  receive {turned_off, Phone} -> e53:stop(phone) end.

idle() ->
  receive
    {Number, incoming} -> ringing(Number);
    off_hook -> dial();
    {turn_off, From} -> From ! {turned_off, self()}
  end.

ringing(Number) ->
  io:format("Bzzzzz!!!~n"),
  receive
    {Number, other_on_hook} -> idle();
    {Number, off_hook} ->
      e53:send_event(phone, {no_billing, incoming, self(), Number}),
      connected(Number);
    {turn_off, From} -> From ! {turned_off, self()}
  end.

dial() ->
  io:format("Tooooooo...~n"),
  receive
    on_hook -> idle();
    {Number, call} -> calling(Number);
    {turn_off, From} -> From ! {turned_off, self()}
  end.

calling(Number) ->
  io:format("Too... too... too...~n"),
  receive
    on_hook -> idle();
    {Number, other_off_hook} ->
      e53:send_event(phone, {start_billing, outgoing, self(), Number}),
      connected(Number);
    {turn_off, From} -> From ! {turned_off, self()}
  after 10000 -> dial() end.

connected(Number) ->
  io:format("Bla-bla-bla...~n"),
  receive
    {Number, other_on_hook} ->
      e53:send_event(phone, {stop_billing, other_on_hook, self(), Number}),
      dial();
    on_hook ->
      e53:send_event(phone, {stop_billing, on_hook, self(), Number}),
      idle();
    {turn_off, From} ->
      e53:send_event(phone, {stop_billing, turned_off, self(), Number}),
      From ! {turned_off, self()}
  end.
