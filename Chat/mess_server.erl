%%% El proceso del servidor

-module(mess_server).
-export([start_server/0, server/0]).
-include("mess_interface.hrl").

server() ->
    process_flag(trap_exit, true),
    server([]).

%%% Lista de usuarios de la forma [{ClientPid1, Name1},{ClientPid22, Name2},...]
server(User_List) ->
    io:format("User list = ~p~n", [User_List]),
    receive
        #login{client_pid=From, username=Name} ->
            New_User_List = server_login(From, Name, User_List),
            server(New_User_List);
        {'EXIT', From, _} ->
            New_User_List = server_logoff(From, User_List),
            server(New_User_List);
        #message{client_pid=From, to_name=To, message=Message} ->
            server_transfer(From, To, Message, User_List),
            server(User_List)
    end.

%%% Empieza a correr el servidor
start_server() ->
    register(messenger, spawn(?MODULE, server, [])).

%%% Agrega un nuevo usuario a la lista
server_login(From, Name, User_List) ->
    %% check if logged on anywhere else
    case lists:keymember(Name, 2, User_List) of
        true ->
            From ! #abort_client{message=user_exists_at_other_node},
            User_List;
        false ->
            From ! #server_reply{message=logged_on},
            link(From),
            [{From, Name} | User_List]        %add user to the list
    end.

%%% Borra un usuario de la lista
server_logoff(From, User_List) ->
    lists:keydelete(From, 1, User_List).

%%% Transfiere el mensaje entre los usuarios
server_transfer(From, To, Message, User_List) ->
    %% Verifica si el usuario está logueado y a que nombre pertenece
    case lists:keysearch(From, 1, User_List) of
        false ->
            From ! #abort_client{message=you_are_not_logged_on};
        {value, {_, Name}} ->
            server_transfer(From, Name, To, Message, User_List)
    end.
%%% Si existe lo envía
server_transfer(From, Name, To, Message, User_List) ->
    %% Busca el receptor y le envía el mensaje
    case lists:keysearch(To, 2, User_List) of
        false ->
            From ! #server_reply{message=receiver_not_found};
        {value, {ToPid, To}} ->
            ToPid ! #message_from{from_name=Name, message=Message}, 
            From !  #server_reply{message=sent} 
    end.