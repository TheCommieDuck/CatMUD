:- module(server, []).
:- use_module([library(socket), verify, utils]).

startup:-
	asserta(assert_stuff:debug_log),
	set_random(seed(69)),
	load_world('basic_facts.pl', 'Basic Facts', _),
	load_world('city.pl', 'City', Success),
	(
		Success = true,
		write_line('Game Loaded!')
		;
		write_line('Game Failed To Load!'),
		retract_all_for_testing
	),
	load_netlayer,
	write_line('setup done!'), nl.

run:-
	repeat,
	fail.

load_netlayer:-
	create_netlayer_server(ServerSocket, Port, Stream),
	thread_create((attach_console, handle_incoming_connections(Stream)), NetLayerThread, [detached(true)]).

create_netlayer_server(ServerSocket, Port, Stream):-
	Port = 33333,
	tcp_socket(ServerSocket),
	tcp_setopt(ServerSocket, reuseaddr),
	tcp_bind(ServerSocket, Port),
	tcp_listen(ServerSocket, 5),
	tcp_open_socket(ServerSocket, Stream).

handle_incoming_connections(Stream):-
	write_line('waiting for more connections..'),
	tcp_accept(Stream, ClientSocket, ClientIP),
	write_line('accepted connection..'),
	thread_create(create_client(ClientSocket, ClientIP), ClientThread, [detatched(true)]),
	handle_incoming_connections(Stream).

create_client(Socket, IP):-
	attach_console,
	setup_call_cleanup(tcp_open_socket(Socket, Stream), handle_client(Socket, IP, Stream), close_connection(Stream)).
	
close_connection(Stream):-
	close(Stream).

handle_client(Socket, IP, Stream):-
	write_line(Stream, 'hi'),
	wait_for_input([Stream], _, infinite),
	read_line_to_codes(Stream, Stuff),
	write_line(Stuff),
	handle_client(Socket, IP, Stream).


