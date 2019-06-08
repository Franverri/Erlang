%% El proceso de un cliente que corre en cada nodo de usuario

-module(mess_client).

-behaviour(gen_server).

-export([init/1]).
-export([client/2]).
-include("mess_interface.hrl").

% user-defined interface functions
-export([start_link/0]).
-export([handle_cast/2]).


start_link() ->
     gen_server:start_link(?MODULE, [], []).

init(_Args) ->
     io:format("ch1 has started (~w)~n", [self()]),
     % If the initialization is successful, the function
     % should return {ok,State}, {ok,State,Timeout} ..
     {ok, ch1State}.

handle_cast(calc, State) ->
     io:format("result 2+2=4~n"),
     {noreply, State};
handle_cast(calcbad, State) ->
     io:format("result 1/0~n"),
     1 / 0,
     {noreply, State}.

%%

client(Server_Node, Name) ->
    {messenger, Server_Node} ! #login{client_pid=self(), username=Name},
    await_result(),
    client(Server_Node).

client(Server_Node) ->
    receive
        logout ->
            exit(normal);
        #message_to{to_name=ToName, message=Message} ->
            {messenger, Server_Node} !
                #message{client_pid=self(), to_name=ToName, message=Message},
            await_result();
        {message_from, FromName, Message} ->
            io:format("Message from ~p: ~p~n", [FromName, Message])
    end,
    client(Server_Node).

%% Espera la respuesta del servidor
await_result() ->
    receive
        #abort_client{message=Why} ->
            io:format("~p~n", [Why]),
            exit(normal);
        #server_reply{message=What} ->
            io:format("~p~n", [What])
    after 5000 ->
            io:format("No response from server~n", []),
            exit(timeout)
    end.
