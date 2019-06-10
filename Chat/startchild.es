#!/usr/bin/env escript
main([]) ->
	client_sup:start_link(),
	{ok, Child1Pid} = supervisor:start_child(client_sup, []),
	{ok, Child2Pid} = supervisor:start_child(client_sup, []),
	erlang:processes(),
	gen_server:cast(Child1Pid, calc),
	gen_server:cast(Child2Pid, calcbad),
	erlang:processes(),
	gen_server:cast(Child2Pid).
