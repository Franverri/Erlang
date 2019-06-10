%% Interfaz de usuario

%% login(Name): se conecta al chatroom con el nombre de usuario especificado como "Name"
%% (Error si ya existe el nombre o si el nodo ya se encuentra logueado)

%% logout(): cierra sesión en el chat

%% message(ToName, Message): envía un mensaje al usuario cuyo nombre de usuario es "ToName"
%% (Error si no existe el usuario al que se le desea enviar el mensaje o si no está iniciada la sesión de mensajero)

-module(user_interface).
-export([login/1, logout/0, message/2]).
-include("mess_interface.hrl").
-include("mess_config.hrl").

login(Name) ->
    case whereis(mess_client) of
        undefined ->
            register(mess_client,
                     spawn(mess_client, client, [?server_node, Name])); %?server_node: macro definida que da valor chat@Franco
        _ -> already_logged_on
    end.

logout() ->
    mess_client ! logout.

message(ToName, Message) ->
    case whereis(mess_client) of % Chequea que el cliente esté corriendo
        undefined ->
            not_logged_on;
        _ -> mess_client ! #message_to{to_name=ToName, message=Message},
             ok
end.
