:-module(utils, [write_line/1, write_line/2, writef_line/2, 
	fact/1,
	make_truncated_uuid/1, generate_ID/2]).

write_debug_message(Message):-
	\+ assert_stuff:debug_log
	;
	thread_send_message(debug_queue, Message).

write_line(Stuff):-
	write(Stuff), nl.

write_line(Stream, Stuff):-
	write(Stream, Stuff),
	nl(Stream),
	flush_output(Stream).

writef_line(Stuff, List):-
	writef(Stuff, List), nl.

fact(Fact):-
	clause(Fact, true).

make_truncated_uuid(IDStr):-
	uuid(UUID),
	atom_string(UUID, UUIDString),
	sub_string(UUIDString, _, 6, 0, IDStr).

generate_ID(Name, ID):-
	make_truncated_uuid(UUID),
	sub_string(Name, _, 8, _, SubStr),
	string_concat(SubStr, UUID, ID),
	\+ clause(things:thing(ID, _), _).