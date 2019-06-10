-module(sup).
-export([start/2, init/1, loop/1]).
 
%Pid = sup:start(c2, []).
%whereis(c2) ! terminate. | whereis(c2) ! shutdown.

start(Mod,Args) ->
	spawn(?MODULE, init, [{Mod, Args}]).
 
init({Mod,Args}) ->
	process_flag(trap_exit, true),
	loop({Mod,start_link,Args}).
 
loop({M,F,A}) -> %M = c2, F = start_link, A = []
	Pid = apply(M,F,A), %Module:Function(Arg1, Arg2, ...). -> Llama a start_link definido en c2 pero desde este proceso
	receive
		{'EXIT', _From, shutdown} ->
			exit(shutdown); 
		{'EXIT', Pid, Reason} ->
			io:format("Process ~p exited for reason ~p~n",[Pid,Reason]),
			loop({M,F,A})
	end.