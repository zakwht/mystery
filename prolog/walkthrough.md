https://xmonader.github.io/prolog/2018/12/21/solving-murder-prolog.html

**Prompt**

> To discover who killed Mr. Boddy, you need to learn where each person was, and what weapon was in the room. To begin, you need to know the suspects. There are three men (George, John, Robert) and three women (Barbara, Christine, Yolanda). Each person was in a different room (Bathroom, Dining Room, Kitchen, Living Room, Pantry, Study). A suspected weapon was found in each room (Bag, Firearm, Gas, Knife, Poison, Rope). Who was found in the kitchen?

---

[**Knowledge Base Setup**](/prolog/prolog.pl#L1-L23)

Initial facts:

```prolog
man(george).
man(john).
man(robert).
woman(barbara).
woman(christine).
woman(yolanda).
person(X):- woman(X); man(X).

room(bathroom).
% ...

weapon(bag).
% ...
```

`uniq_ppl` helper rule asserts each person is in a distinct room and has a distinct weapon:

```prolog
uniq_ppl(A,B,C,D,E,F):- 
  person(A), person(B), person(C), person(D), person(E), person(F),
  \+A=B, \+A=C, \+A=D, \+A=E, \+A=F, \+B=C, \+B=D, \+B=E, \+B=F,
  \+C=D, \+C=E, \+C=F, \+D=E, \+D=F, \+E=F.

uniq_ppl(Bathroom, Dining, Kitchen, Living, Pantry, Study),
uniq_ppl(Bag, Firearm, Gas, Knife, Poison, Rope),
```

---

[**Clue 1**](/prolog//prolog.pl#L46)

The man in the kitchen was not found with the rope, knife, firearm, or bag.

```prolog
man(Kitchen), \+Kitchen=Rope, \+Kitchen=Knife, \+Kitchen=Bag, \+Kitchen=Firearm,
```

---

[**Clue 2**](/prolog//prolog.pl#L49)

Barbara was either in the study or the bathroom; Yolanda was in the other.

```prolog
(barbara=Bathroom, yolanda=Study; barbara=Study, yolanda=Bathroom),
```

---

[**Clue 3**](/prolog//prolog.pl#L52)

The person with the bag, who was not Barbara nor George, was not in the bathroom nor the dining room. 

```prolog
\+barbara=Bag, \+george=Bag, \+Bag=Bathroom, \+Bag=Dining,
```

---

[**Clue 4**](/prolog//prolog.pl#L55)

The woman with the rope was found in the study.

```prolog
woman(Rope), Rope=Study,
```

---

[**Clue 5**](/prolog//prolog.pl#L58)

The weapon in the living room was found with either John or George.

```prolog
(john=Living; george=Living),
```

---

[**Clue 6**](/prolog//prolog.pl#L61)

The knife was not in the dining room.

```prolog
\+Knife=Dining,
```

---

[**Clue 7**](/prolog//prolog.pl#L64)

Yolanda was not with the weapon found in the study nor the pantry.

```prolog
\+yolanda=Study, \+yolanda=Pantry,
```

---

[**Clue 8**](/prolog//prolog.pl#L67)

The firearm was in the room with George. 

```prolog
george=Firearm,
```

---

[**Clue 8**](/prolog//prolog.pl#L70)

It was discovered that Mr. Boddy was gassed in the pantry. The suspect found in that room was the murderer.

```prolog
Pantry=Gas, Gas=X.
```

---

**Solving the case**

```prolog
?- murderer(X).
X = christine
```



