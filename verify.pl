:- module(verify, [load_game/2, retract_all_for_testing/0]).

:-use_module([library(uuid), assert_stuff]).



make_truncated_uuid(IDStr):-
	uuid(UUID),
	atom_string(UUID, UUIDString),
	sub_string(UUIDString, _, 5, _, IDStr).

generate_ID(Name, ID):-
	make_truncated_uuid(UUID),
	sub_string(Name, _, 8, _, SubStr),
	string_concat(SubStr, UUID, ID),
	\+ clause(things:thing(ID, _), _).

load_game([Rule|Rules], Success):-
	assert_game_rule(Rule),
	load_game(Rules, Success).

load_game([], true).

load_game(_, false).

%
% Create objects/rooms
%

assert_game_rule(dig(Name)):-
	assert_game_rule(create(room, Name)).

assert_game_rule(dig(Name, ID)):-
	assert_game_rule(create(room, Name)).

assert_game_rule(dig(Name, ID, Properties)):-
	assert_game_rule(create(room, Name, ID, Properties)).

assert_game_rule(create(Type, Name)):-
	assert_game_rule(create(Type, Name, _, [])).

assert_game_rule(create(Type, Name, ID)):-
	assert_game_rule(create(Type, Name, ID, [])).

assert_game_rule(create(Type, Name, ID, Properties)):-
	(
	var(ID),
	generate_ID(Name, ID)
	;
	\+ clause(things:thing(ID, _), _)
	), !,
	assert_thing(thing(ID, Type)),
	assert_thing(display_name(ID, Name)), !,
	assert_properties(ID, Properties),
	b_setval(active_object, ID).

assert_game_rule(description(Desc)):-
	b_getval(active_object, Obj),
	assert_game_rule(description(Obj, Desc)).

assert_game_rule(description(ID, Desc)):-
	assert_thing_overwrite(description(ID, Desc)).

assert_game_rule(exit(Direction, ToID, ExitID)):-
	b_getval(active_object, Obj),
	assert_game_rule(exit(Obj, Direction, ToID, PassageID)).

assert_game_rule(exit(FromID, Direction, ToID, PassageID)):-
	assert_game_rule(create(passage, 'Passageway', ExitID)).

% base
assert_game_rule(X):-
	writef('No idea what %w is!', [X]), !, nl, fail.

assert_properties(_, []).
assert_properties(ID, [Prop|Props]):-
	Prop =.. [Property|Args],
	NewProp =.. [Property, ID|Args],
	assert_game_rule(NewProp), !,
	assert_properties(ID, Props).

retract_all_for_testing:-
	debug,
	retractall(things:thing(_,_)),
	retractall(things:display_name(_,_)).