man(george).
man(john).
man(robert).
woman(barbara).
woman(christine).
woman(yolanda).
person(X):- woman(X); man(X).

room(bathroom).
room(diningroom).
room(kitchen).
room(livingroom).
room(pantry).
room(study).

weapon(bag).
weapon(firearm).
weapon(gas).
weapon(knife).
weapon(poison).
weapon(rope).

uniq_ppl(A,B,C,D,E,F):- person(A), person(B), person(C), person(D), person(E), person(F), \+A=B, \+A=C, \+A=D, \+A=E, \+A=F, \+B=C, \+B=D, \+B=E, \+B=F, \+C=D, \+C=E, \+C=F, \+D=E, \+D=F, \+E=F.

% writevals(Bathroom, Dining, Kitchen, Living, Pantry, Study, Bag, Firearm, Gas, Knife, Poison, Rope) :-
%   nl, write(" Locations "), nl,
%   write("Bathroom: "), write(Bathroom), nl,
%   write("Dining Room: "), write(Dining), nl,
%   write("Kitchen: "), write(Kitchen), nl,
%   write("Living Room: "), write(Living), nl,
%   write("Pantry: "), write(Pantry), nl,
%   write("Study: "), write(Study), nl,
%   nl, write(" Weapons "), nl,
%   write("Bag: "), write(Bag), nl,
%   write("Firearm: "), write(Firearm), nl,
%   write("Gas: "), write(Gas), nl,
%   write("Knife: "), write(Knife), nl,
%   write("Poison: "), write(Poison), nl,
%   write("Rope: "), write(Rope), nl.

murderer(X):-
  uniq_ppl(Bathroom, Dining, Kitchen, Living, Pantry, Study),
  uniq_ppl(Bag, Firearm, Gas, Knife, Poison, Rope),

  % clue 1 
  man(Kitchen), \+Kitchen=Rope, \+Kitchen=Knife, \+Kitchen=Bag, \+Kitchen=Firearm,

  % clue 2 
  (barbara=Bathroom, yolanda=Study; barbara=Study, yolanda=Bathroom),

  % clue 3 
  \+barbara=Bag, \+george=Bag, \+Bag=Bathroom, \+Bag=Dining,

  % clue 4
  woman(Rope), Rope=Study,

  % clue 5 
  (john=Living; george=Living),

  % clue 6 
  \+Knife=Dining,

  % clue 7 
  \+yolanda=Study, \+yolanda=Pantry,

  % clue 8 
  george=Firearm,

  % clue 9 
  Pantry=Gas, Gas=X, 
  
  % writevals(Bathroom, Dining, Kitchen, Living, Pantry, Study, Bag, Firearm, Gas, Knife, Poison, Rope) 
  .

