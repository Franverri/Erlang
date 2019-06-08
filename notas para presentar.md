Versión: Erlang/OTP 22
Extensiones: .erl (Erlang), .ehl (Erlang header), .exs (Elixir), .es (Erlang script, escript), .beam (compilados)


## Características

* Compilado a bytecode para ser corrido en la EVM (Erlang Virtual Machine)
* Funcional
* Fault tolerance
* Inmutabilidad - para reducir la incertidumbre (single assignment)
* Dynamic and strongly typed [no hace falta aclarar tipos pero no podés sumar distintos]
* Concurrencia, modelo de actores, colas de mensajes (locks implícitos), "Everything is a process", con nombres únicos a los cuales se les puede enviar mensajes
* Garbage collected
* Hot swappable o "hot code loading" ("por sus interfaces bla bla bla")
* Eager evaluation


## Demo erlang
Mostrar sintaxis en el código. Algunas cosas a mencionar:

* Comentarios con %%
* Se declara módulo y exports (se puede exportar todo pero no es recomendado)
* Se usan en la forma `my_module:my_function()`, funciones especiales: `my_module:module_info()`
* Behaviour (símil `interface` en Java?)
* Forma general del código
	* Funciones `->`, comas (_andalso_), punto y comas (_orelse_), puntos
	* ("Esto les puede hacer acordar a Haskell...")
* Mayúsculas para variables, minúscula para átomos (símil símbolos en Ruby)
* Listas 1-indexed
* Pattern matching (separando ;), guards (con `when`) [un ejemplo para tener a mano]
```
greet(_, Name) when string:length(Name) > 12 -> "No puedo pronunciar eso..."
greet(male, Name) ->
	"Buenas tardes.";
greet(female, Name) ->
	"Holaaaaaa q tal? :)";
greet(_, Name) ->
	{default}.
```
También existe dentro de las funciones (e.g. con `receive`)
* `=:=` vs `==` (símil JS). El = sirve como asignación si está unbound, como comparación si no
* Curioso if/else
```
if N =:= 2 -> might_succeed;
   true -> always_does  %% this is Erlang's if's 'else!'
end.
```
* Facilidad de lanzar actores y cómo se puede hacer `register`
`ChildPid = spawn(modulo, funcion, [args]).`
* Facilidad para enviar...
```
PongPid ! {ping, self()}.` | `PongPid ! {ping, "Te espero"}
```
... y recibir mensajes
```
receive ...
```
`self()` entrega Pid propio


* Mostrar `one_for_all` vs `one_for_one` ?
* Compilar en `erl` o con `erlc` ?
* Macros, como `?MODULE`
* Hot swapping....




### Eso es todo lo bueno... ¿y lo malo?
* Mensajes de errorr inenentendeinswabdslkjfnas;lk [algún ejemplo?]
* Aunque bastante popular, no es de los lenguajes más queridos [acá mostrar rankings]
* "En un momento nos hartamos del punto, así que pasamos a Elixir..." [mostrar que está más arriba]

## Elixir
("2x1!")

Elixir es...

* Simplicidad del lenguaje
- Qué otras ventajas?
* Cosas hechas en Elixir: Pinterest, Discord, Moz, Bleacher Report

[Decir qué es Phoenix y pasar a la...]

### Demo elixir
Con chat mega rápido e interfaz incluida
`mix phx.gen.channel NOMBRE`
.....


--------

# Falta
* Garbage collector
* actores?
* desarrollar lo de Elixir, para llenar tiempo
* Overloading?
* Error handling?
* Records!
* Hot swapping, hay un buen ejemplo en Wikipedia, incluirlo en el código (testearlo antes plz)
* Hablar de los ppios de diseño de la OTP ?

### Para las diapos:
* Agregar diagrama de árbol (supervisor etc)

%% Verificar si los módulos se escriben con mayúscula
%% borrar DB Chat example app de mi compu (postgres)
%% siempre el módulo antes ?? averiguar si se puede ahorrar
