-module(e52).
-export([start/0, stop/0, allocate/0, deallocate/1]).

start() ->
    Pid = spawn(fun() -> loop({get_frequencies(), []}) end),
    register(?MODULE, Pid).

stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}=Orig, Pid) ->
    AllocatedByPid = lists:filter(fun({_, P}) -> P == Pid end, Allocated),
    if length(AllocatedByPid) >= 3 -> {Orig, {error, no_frequency}};
       true -> {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}
    end.

deallocate({Free, Allocated}=Orig, Freq, Pid) ->
    case lists:member({Freq, Pid}, Allocated) of
	false -> Orig;
	true -> {[Freq|Free], lists:delete({Freq, Pid}, Allocated)}
    end.

call(Message) ->
    ?MODULE ! {request, self(), Message},
    receive {reply, Reply} -> Reply end.

reply(Pid, Reply) ->
    Pid ! {reply, Reply}.

loop(Frequencies) ->
    receive
	{request, Pid, allocate} ->
	    {NewFrequencies, Reply} = allocate(Frequencies, Pid),
	    reply(Pid, Reply),
	    loop(NewFrequencies);
	{request, Pid, {deallocate, Freq}} ->
	    NewFrequencies = deallocate(Frequencies, Freq, Pid),
	    reply(Pid, ok),
	    loop(NewFrequencies);
	{request, Pid, stop} ->
	    case Frequencies of
		{_, []} -> reply(Pid, ok);
		_ -> reply(Pid, {error, still_allocated}),
		     loop(Frequencies)
	    end
    end.

get_frequencies() -> [10,11,12,13,14,15].
