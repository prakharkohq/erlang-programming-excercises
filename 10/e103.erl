-module(e103).
-export([test/0]).
-include_lib("stdlib/include/ms_transform.hrl").

-define(M, 1000000).

timestamp() ->
    {Mega, Sec, Micro} = now(),
    Mega * ?M * ?M + Sec * ?M + Micro.

server_loop(Avger) ->
    receive
	{ack, M, AckTs} ->
	    ets:insert(messages, {M, AckTs}),
	    Avger ! acked;
	{_Ts, _Msg, From}=M ->
	    ets:insert(messages, {M, nil}),
	    From ! {ack, M}
    end,
    server_loop(Avger).

avger_loop() ->
    receive acked ->
        Now = timestamp(),
        RecentAckLagSpec = ets:fun2ms(
	    fun({{Sent, _, _}, Ack}) when Ack /= nil,
					  (Now - Sent) =< ?M -> Ack - Sent end),
	report_avg(ets:select(messages, RecentAckLagSpec)),
        avger_loop()
    end.

report_avg([]) -> ok;
report_avg(Recent) ->
    LagAvg = round(lists:sum(Recent) / length(Recent)),
    io:format("Lag average of recent messages is ~pµs~n", [LagAvg]).

test() ->
    Avger = spawn(fun avger_loop/0),
    Server = spawn(fun() ->
	ets:new(messages, [ordered_set, named_table]),
	server_loop(Avger) end),
    Client = fun(Client) ->
        receive after 500 ->
	    M = {timestamp(), ping, self()},
	    Server ! M,
	    receive {ack, M} -> Server ! {ack, M, timestamp()} end,
	    Client(Client)
	end
    end,
    spawn(fun() -> Client(Client) end).
