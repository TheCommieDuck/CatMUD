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

