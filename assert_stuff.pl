:- module(assert_stuff, [fact/1, assert_thing/1, assert_thing_overwrite/1]).
:- use_module(utils).


create_predicate_template(Original, Arg_Position, New):-
	functor(Original, Name, Arity),
	functor(New, Name, Arity),
	arg(Arg_Position, Original, Arg),
	arg(Arg_Position, New, Arg).

assert_thing_overwrite(Thing):-
	create_predicate_template(Thing, 1, ExistingThing),
	(
		retract(things:ExistingThing),
		(debug_log, writef('Asserting/overwriting %w.', [Thing]), nl ; true),
		asserta(things:Thing), !
		;
		(debug_log, writef('Asserting %w.', [Thing]), nl ; true),
		asserta(things:Thing)
	).

%deconstruct the predicate Foo(ID, a, b, c...) and construct Foo(ID, X, Y, Z...); i.e. the existing term
assert_thing(Thing):-
	create_predicate_template(Thing, 1, ExistingThing),
	(
		clause(things:ExistingThing, _),
		(debug_log, writef('%w was already asserted', [Thing]), nl ; true)
		;
		(debug_log, writef('Asserting %w.', [Thing]), nl ; true),
		asserta(things:Thing)
	).

assert_stuff_with_cleanup(Things, Condition, UUID, Success):-
	assert_stuff_with_cleanup(Things, Condition, asserta, UUID, Success).

assert_stuff_with_cleanup(Things, Condition, Assert, UUID, Success):-
	uuid(UUID, []),
	nb_setval(UUID, []),
	assert_stuff_with_cleanup(Things, UUID, Assert, Condition, [], Success).

assert_stuff_with_cleanup([], UUID, _, _, References, Success):-
	Success = true,
	nb_setval(UUID, References).

assert_stuff_with_cleanup([Thing|Things], UUID, Assert, Condition, Cleanup, Success):-
	call(Condition, Thing),
	call(Assert, Thing, Ref_Things),
	(
		debug,
		writef('Asserting %w!\n', [Thing])
		;
		true
	),
	duplicate_all_terms(Ref_Things, Ref_Things_Duplicate),
	append(Ref_Things_Duplicate, Cleanup, Ref_List),
	assert_stuff_with_cleanup(Things, UUID, Assert, Condition, Ref_List, Success),
	!;
	Success = false,
	cleanup_ref(Cleanup).

cleanup_ref(Refs):-
	forall(member(X, Refs), erase(X)).
	
cleanup(Ref):-
	nb_getval(Ref, ToCleanup),
	cleanup_ref(ToCleanup).

duplicate_all_terms([], []).
duplicate_all_terms([R|Rs], [R2|R2s]):-
	duplicate_term(R, R2),
	duplicate_all_terms(Rs, R2s).
duplicate_all_terms(R, [R2]):-
	duplicate_term(R, R2).

