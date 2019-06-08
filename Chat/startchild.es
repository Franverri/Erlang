#!/usr/bin/env escript
main([]) ->
	client_sup:start_link(),
	{ok, Child3Pid} = supervisor:start_child(client_sup, []),
	{ok, Child4Pid} = supervisor:start_child(client_sup, []),
	erlang:processes(),
	gen_server:cast(Child3Pid, calc),
	gen_server:cast(Child4Pid, calcbad),
	erlang:processes(),
	gen_server:cast(Child4Pid).
