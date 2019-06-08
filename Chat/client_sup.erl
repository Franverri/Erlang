% -module(client_sup).
% -behaviour(supervisor).
%
% -export([start_link/0]).
% -export([init/1]).
%
% start_link() ->
%     supervisor:start_link(client_sup, []).
%
% init(_Args) ->
%     RestartStrategy = one_for_all, % one_for_one
%     SupFlags = #{strategy => RestartStrategy,
%                  intensity => 1, period => 5},
%     ChildSpecs = [#{id => mess_client,
%                     start => {mess_client, start_link, []},
%                     restart => permanent,
%                     shutdown => brutal_kill,
%                     type => worker,
%                     modules => [mess_client]}],
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
