:-module(utils, [write_line/1, writef_line/2]).

write_line(Stuff):-
	write(Stuff), nl.

writef_line(Stuff, List):-
	writef(Stuff, List), nl.