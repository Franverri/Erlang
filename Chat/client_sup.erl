% init(_Args) ->
%     RestartStrategy = one_for_all, % one_for_one
%     SupFlags = #{strategy => RestartStrategy,
%                  intensity => 1, period => 5},
%     ChildSpecs = [#{id => mess_client, 						%%id is used to identify the child specification internally by the supervisor.
%                     start => {mess_client, start_link, []}, 	%%start defines the function call used to start the child process. It is a module-function-arguments tuple used as apply(M, F, A).
%                     restart => permanent,						%%restart defines when a terminated child process is to be restarted.
																	%%A permanent (default) child process is always restarted.
																	%%A temporary child process is never restarted (not even when the supervisor restart strategy is rest_for_one or one_for_all and a sibling death causes the temporary process to be terminated).
																	%%A transient child process is restarted only if it terminates abnormally, that is, with an exit reason other than normal, shutdown, or {shutdown,Term}.

%                     shutdown => brutal_kill,					%%shutdown defines how a child process is to be terminated.
																	%%brutal_kill means that the child process is unconditionally terminated using exit(Child, kill).
																	%%An integer time-out value means that the supervisor tells the child process to terminate by calling exit(Child, shutdown) and then waits for an exit signal back. If no exit signal is received within the specified time, the child process is unconditionally terminated using exit(Child, kill).
																	%%If the child process is another supervisor, it must be set to infinity to give the subtree enough time to shut down. It is also allowed to set it to infinity, if the child process is a worker.
%                     												%%DEFAULT: 500 worker - Infinito suervisor
%					  type => worker, 							%%supervisor or worker (Default)
%                     modules => [mess_client]}],				%%modules are to be a list with one element [Module], where Module is the name of the callback module, if the child process is a supervisor, gen_server, gen_statem. If the child process is a gen_event, the value shall be dynamic.
%																	%%DEFAULT: [M], where M comes from the child's start {M,F,A}.
%     Children = [ChildSpecs],
%     {ok, {SupFlags, Children}}.
-module(client_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
     {ok, Pid} = supervisor:start_link({local, ?MODULE},
          ?MODULE, []),
     {ok, Pid}.

init(_Args) ->
     RestartStrategy = {simple_one_for_one, 10, 60},
     ChildSpec = {mess_client, {mess_client, start_link, []},
          permanent, brutal_kill, worker, [mess_client]},
     Children = [ChildSpec],
     {ok, {RestartStrategy, Children}}.
