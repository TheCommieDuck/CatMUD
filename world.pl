:-use_module([parser, verify]).

go:-
	asserta(debug).

main:-
	startup,
	run,
	shutdown.

startup:-
	go,
	set_random(seed(69)),
	read_file_to_terms('basic_facts.pl', Terms, []),
	load_game(Terms, _), !,
	load_world('city.pl'),
	write('setup done!'), !.

run:-
	repeat,
	sleep(0.1),
	tick,
	!, fail.

tick:-
	get_player_action(me, Action),
	do_player_action(me, Action).

%~~~~~~~~~~~~~~~~%
% Handle Actions %
%~~~~~~~~~~~~~~~~%

get_player_action(Actor, Action):-
	write('> '),
  	read_line_to_codes(user_input, Codes), nl,
  	atom_codes(Atomic_Input, Codes),
  	tokenize_atom(Atomic_Input, Command_List),
  	parse(Command_List, Action).

do_player_action(Actor, Action):-
	writef('%w does the %w', [Actor, Action]).

load_world(File):-
	write('Loading game..'), nl,
	read_file_to_terms(File, Terms, []),
	load_game(Terms, Success),
	(
		Success = true,
		write('Game Loaded!')
		;
		write('Game Failed To Load!'),
		retract_all_for_testing
	),
	nl.