:-use_module([parser, verify, server, utils]).

main:-
	server:startup,
	server:run,
	shutdown.

shutdown:-
	write_line('Goodbye.').