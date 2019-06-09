-module(c1).
%-export([start/0, say_something/2]).
%-export([send_something/2]).
-compile(export_all).

say_something(What, 0) ->
    done;
say_something(What, Times) ->
    io:format("~p~n", [What]),
    say_something(What, Times - 1).

send_something(What, 0) ->
	done;
send_something(What, Times) ->
	self() ! What,
	send_something(What, Times -1).

receive_something() ->
	receive 
		hola -> io:format("Te están saludando~n");
		chau -> io:format("Se están despidiendo~n");
		_ ->	io:format("No entiendo~n"),
				receive_something()
	end.

rcv_snd_some() ->
	receive
		{From, hola} ->
			From ! "Te están saludando",
			rcv_snd_some();
		{From, chau} ->
			From ! "Se están despidiendo",
			rcv_snd_some();
		_ ->	io:format("No entiendo!~n")
	end.

start() ->
    spawn(c1, say_something, [hello, 3]),
    spawn(c1, say_something, [goodbye, 3]).