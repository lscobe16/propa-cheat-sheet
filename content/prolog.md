\newpage
# Prolog

## Generelles Zeug
Prolog ist nicht vollständig da die nächste Regel deterministisch gewählt wird, daher können Endlosschleifen entstehen und keine Lösung gefunden werden obwohl sie existiert.

Kleingeschriebene Wörter sind Atome. Großbuchstaben sind Variablen. `_` ist Platzhalter-Variable.

Prädikat heißt deterministisch gdw. es stets auf höchstens eine Weise erfüllt werden kann.

```prolog
% Prolog erfüllt Teilziele von links nach rechts
foo(X) :- subgoal1(X), subgoal2(X), subgoal3(X).

% ! = Cut = alles links (inklusive Prädikat links von :-) ist nicht reerfüllbar.
% Arten von Cuts:
%  - Blauer Cut: beeinflusst weder Programmlaufzeit, noch -verhalten
%  - Grüner Cut: beeinflusst Laufzeit, aber nicht Verhalten
%  - Roter Cut: beeinflusst das Programmverhalten (häufig: letzten Wächter unnötig machen)
% Faustregel: Cut kommt, wenn wir sicher im richtigen Zweig sind, Ergebnisse danach
foo(X, Y) :- operation_where_we_only_want_the_first_result(X, Z), !, Y = Z.
```

\Begin{multicols}{2}
``` prolog
% Idiom: generate and test
foo(X, Y) :- generator(X, Y), tester(Y).
% z.B.:
nat(0).
nat(X) :- nat(Y), X is Y+1.
sqrt(X,Y) :- nat(Y),
    Y2 is Y*Y, Y3 is (Y+1)*(Y+1),
    Y2 =< X, X < Y3.
% Früher testen => effizienter
```
\columnbreak

```prolog
% Listen mit Cons:
[1,2,3] = [1|[2|[3|[]]]].
[1,2,3|[4,5,6,7]] = [1,2,3,4,5,6,7].
% === Arithmetik
% erstmal nur Terme:
2 - 1 \= 1.
% Auswerten mit "is":
N1 is N - 1.
% Arithmetische Vergleiche:
% Argumente müssen instanziiert sein!
=:=, =\=, <,=<, >, >=
even/1, odd/1 % Generatoren aus VL
```
\End{multicols}

\vspace{-3em}
## Wichtige Funktionen

Built-In:
\Begin{multicols}{2}
```prolog
% member(X, L): X ist in Liste L  (alle Richtungen)
member(X,[X|R]).
member(X,[Y|R]) :- member(X,R).

% append(A, B, C): C = A ++ B  (alle Richtungen)
append([],L,L).
append([X|R],L,[X|T]) :- append(R,L,T).
```
\columnbreak
```prolog
% delete(A, X, B): B = alle X aus A entfernen (aR)
delete([X|L],X,L).
delete([X|L],Y,[X|L1]) :- delete(L,Y,L1).

% reverse(L, R): R ist Liste L rückwerts  (aR)
reverse([],[]).
reverse([X|R],Y) :- reverse(R,Y1),append(Y1,[X],Y).
```
\End{multicols}
```prolog
% N ist Länger der Liste L   (alle Richtungen)
length(L, N).

% Prüft, ob Prädikat X erfüllbar ist (NICHT: findet Instanziierung, sodass X nicht erfüllt ist)
not(X) :- call(X),!,fail.
not(X).

% Prüft, dass nicht gleich  (alle Richtungen)
dif(X, Y) :- when(?=(X,Y), X \== Y)

% Meta
atom(X). % Prüft ob X ein Atom ist
integer(X). % Prüft ob X eine Zahl ist
atomic(X). % Prüft ob X ein Atom oder eine Zahl ist
```

Weiter:
```prolog
% Prüft ob Permutation voneinander. Iteriert durch alle Permutationen bei Reerfüllung   (alle Richtungen)
permute([],[]).
permute([X|R],P) :- permute(R,P1),append(A,B,P1),append(A,[X|B],P).

% lookup(N, D, A) mit A uninstanziiert: A <- D[N] nachschauen
% lookup(N, D, A) mit A instanziiert: D[N] <- A setzen (überschreiben nicht möglich)
% Vorteil ggü. member((N, A), D): nur Einträge am Anfang -> keine Reerfüllung
lookup(N,[(N,A)|_],A1) :- !,A=A1.
lookup(N,[_|T],A) :- lookup(N,T,A).

% QuickSort: qsort(L, SortedL)   (nur vorwärts)
qsort([],[]).
qsort([X|R],Y) :- split(X,R,R1,R2), qsort(R1,Y1), qsort(R2,Y2), append(Y1,[X|Y2],Y).
split(X,[],[],[]).
split(X,[H|T],[H|R],Y) :- X>H, split(X,T,R,Y).
split(X,[H|T],R,[H|Y]) :- X=<H, split(X,T,R,Y).
```

