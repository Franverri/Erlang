-module(c2).
-compile(export_all).

%-----------------------------------------------

%Estado: usuarios
%P1 = spawn(c2, chat_room, [[franco, martin]]).

chat_room(UsrList) ->
    receive
    {From, User} ->
        case lists:member(User, UsrList) of
            true ->
                From ! {self(), {encontrado, User}},
                chat_room(UsrList);
            false ->
                From ! {self(), no_encontrado},
                chat_room(UsrList)
        end;
    {From, delete, User} ->
        case lists:member(User, UsrList) of
            true ->
                From ! {self(), {borrado, User}},
                chat_room(lists:delete(User, UsrList));
            false ->
                From ! {self(), no_encontrado},
                chat_room(UsrList)
        end;
    terminate ->
        exit("RIP");
    shutdown ->
        exit(shutdown)
    end.

start() ->
    register(?MODULE, Pid=spawn(?MODULE, init, [])),
    Pid.

%-----------------------------------------------

start_link() ->
    register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
    Pid.

init() ->
    chat_room([franco]).