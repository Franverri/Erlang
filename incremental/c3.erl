-module(c3).
-compile(export_all).

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
        %exit("RIP");
        exit("RIP V 2.0");
    shutdown ->
        exit(shutdown);
    code_swap ->
        c3:chat_room(UsrList)
    end.

start() ->
    register(?MODULE, Pid=spawn(?MODULE, init, [])),
    Pid.

start_link() ->
    register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
    Pid.

init() ->
    chat_room([franco]).