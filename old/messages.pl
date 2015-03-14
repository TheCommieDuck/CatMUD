:-module(messages, [give_message/1, give_message/2]).

write_list([]).
write_list([H|T]):-
	write(H),
	nl,
	write_list(T).

give_message(line_break):-
	nl.

give_message(taking_inventory, []):-
	write("You don't have anything on you.").

give_message(taking_inventory, List):-
	write("You are carrying:"),
	nl,
	write_list(List).

give_message(look, dark_room):-
	write("In Darkness."),
	nl,
	write("It's pitch black. You can't see a thing."),
	nl.