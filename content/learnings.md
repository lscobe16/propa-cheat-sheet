\newpage
# Learnings aus Altklausuren

- Allgemein
	- Beispiele anschauen, insbesondere für Edgecases/Ausgabeformate
	- Haskell fehleranfällig und zeitaufwändig -> zuletzt machen
	- Laberaufgabe -> auf jeden Fall mal in CheatSheet schauen!
	- Am Ende
		- schauen, dass alle Teilaufgaben bearbeitet
		- Alle gegebenen Funktionen benutzt? (kann schon passieren, dass nicht benötigt, aber dann sei dir sicher)
- Haskell
	- Vorsicht bei unendlichen Listen: length divergiert
	- Enums: Typ vs Variante beachten (Variante ist meist nett kurz benannt)
	- Maybe: Just und Nothing nicht vergessen!
	- nicht `first`, sondern `fst` oder `head`
	- `case ... of ...` ist häufig schöner als guard oder helper
	- Lieber mehr Klammern als weniger oder `$`
	- List comprehension loopt über letzten Generator zuinnerst
	- Bei Strings in Array auf genug Schachtelung achten
	- schneller check: alle Eingaben der Funktion verwendet?
- Prolog
	- Pattern Matching vollständig?
	- Reihenfolge der Teilziele am besten in der Reihenfolge, in der du es berechnen würdest (sicherer)
	- es gibt viel, das sich einfach mit `member` oder `append` ausdrücken lässt
	- Gegebene Tester-Prädikate nicht als Generator nutzen
- Lamda-Kalkül
	- Betareduktionen: abwechselnd einsetzen und ableiten, Klammern in extra Schritt erst weglassen (zeigen, dass keine Stringsubstitution)
	- Variablen in Typen sind implizit allquantifizeirt (insb. in "allgemeinster Typ"), Quantoren sind in Typschemata und die sind nur in $\Gamma$
	- Bei VAR oben keine neue Variable einführen sondern wirklich auswerten
- Parallelismus
	- Wenn Synchronisationsbedarf gefordert ist, dann schreib Synchronisationsbedarf hin!
	- Wenn du Begriffe verwenden "kannst", dann verwende Begriffe (z.B. Ursprungsindex)
- MPI
	- counts sind immer pro Prozessor
- Java Multithreading
	- Synchronization verhindert Race Conditions
	- Race Condition ist dann wenn wirklich "gleichzeitig" auf einen Resource zugegriffen wird
		- Für Beispielablauf: Lasse A bis nach einem Check laufen, Lasse B durchlaufen, Lasse A fertig laufen -> Sideeffekt von A überschreibt B
	- Gucken: wann wird get auf Futuers aufgerufen?
	- Meist reicht eine `volatile` variable, da happens-before transitiv ist
- Parser
	- gegebene Funktionen nur in ihrem Definitionsbereich aufrufen
	- Indizmenge = First(alpha Follow)
	- Beim übernehmen von EOF in Indizmengen aufpassen!
	- in `case` muss nicht immer das gematchte Token konsumiert werden. Nur wenn es in dieser Produktion selbst vorkommt
	- Grammatik-Ableitungsschritte angeben = $\Rightarrow$-Kette
	- Wenn AST erzeugt werden soll: `default: error(); return null;`
- Java Bytecode
	- `iload i` statt `iload_i` verwenden
	- Bei Java angeben
		- Am Bytecode Abschnitte markieren, Variablennamen überall hinschreiben, Terme zusammenfassen
		- Klasse drumrum packen
		- wir können eigentlich nur `while`-Schleifen und keine `for`-Schleifen

<!-- 
Gemachte AKs:
- SS 23
- WS 22/23
- SS 22
- WS 21/22
- SS 21 teils
- WS 18/19 
-->

