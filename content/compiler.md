# Compiler

\Begin{multicols}{2}
- **Lexikalische Analyse (Lexing)**
  - Eingabe: Sequenz von Zeichen
  - Aufgaben:
    - erkenne Tokens = bedeutungstragende Zeichengruppen
    - überspringe unwichtige Zeichen (Whitespace, Kommentare)
    - Bezeichner identifizieren und zusammenfassen in Stringtabelle
  - Ausgabe: Sequenz von Tokens und Stringtabelle

- **Syntaktische Analyse (Parsing)**
  - Eingabe: Sequenz von Tokens
  - Aufgaben:
    - überprüfe, ob Eingabe zu kontextfreier Sprache gehört
    - erkenne hierarchische Struktur der Eingabe
  - Ausgabe: Abstrakter Syntaxbaum (AST)

\columnbreak
- **Semantische Analyse**
  - Eingabe: Syntaxbaum
  - Aufgaben: kontextsensitive Analyse (syntaktische Analyse ist kontextfrei)
    - Namensanalyse: Beziehung zwischen Deklaration und Verwendung
    - Typanalyse: Bestimme und prüfe Typen von Variablen, Funktionen, ...
    - Konsistenzprüfung: Alle Einschränkungen der Programmiersprache eingehalten
  - Ausgabe: attributierter Syntaxbaum (Pfeile von Verwendung zu Definition)
  - Ungültige Programme werden spätestens in Semantischer Analyse abgelehnt

- **Zwischencodegenerierung, Optimierung**

- **Codegenerierung**
  - Eingabe: Attributierter Syntaxbaum oder Zwischencode
  - Aufgaben: Erzeuge Code für Zielmaschine (Maschinenbefehle wählen, Scheduling, Registerallokation, Nachoptimierung)
  - Ausgabe: Program in Assembler oder Maschinencode

\End{multicols}
\vspace{-4em}

## Grammatiken

### Eigenschaften
Links- / Rechtsableitung: linkestes / rechtestes Nichtterminal wird zuerst weiterverarbeitet  
Links- / rechtsrekursiv: Rekursion nur am linken / rechten Ende von rechter Seite von Produktionen  
Eindeutig: für jedes Wort existiert nur eine Ableitungsbaum  
Konkreter Syntaxbaum (CST) = Ableitungsbaum (jedes Zeichen ein eigener Knoten, alle Terminale sind Blätter)

### Konstruktion

- Operator precedence: Ein Nichtterminal pro Level, schwächer bindende bilden auf stärker bindende ab, Klammern am Ende
  - Bsp: $P = \{E \to T, T \to F, T \to T * F, E \to E + T, F \to id, F \to ( E )\}$
- Linksassoziativ durch Linksrekursion: $E \to E + T$, Rechtsassoziativ durch Rechtsrekursion: $E \to T + E$
- Nicht zweimal das gleiche Nichtterminal in einem Ersetzungsstring
- Linksfaktorisierung: gleiche Präfixe von auslagern $\Rightarrow$ rechte Seiten zu einem Nichtterminal präfixfrei

### Parsing

- LL: Parser liest einmal von Links nach rechts und baut Linksableitung auf (top-down, recursive decent)
- LR: Parser liest einmal von Links nach rechts und baut Rinksableitung auf (bottom-up)
- SLL(k) / SLR(k): vorherige Zeichen nicht relevant, $k$ langer Lookahead

Für $\chi \in (\Sigma \cup V)^*$:  
$\text{First}_k(\chi) = \{\beta \mid \exists \tau \in \Sigma^* : \chi \Rightarrow^* \tau \land \beta = \tau[..k]\} =$
k-Anfänge der Strings, die aus $\chi$ generiert werden können  
$\text{Follow}_k = \{\beta \mid \exists \alpha, \omega \in (\Sigma \cup V)^* \text{ mit } S \Rightarrow^* \alpha \chi \omega \land \beta \in \text{First}_k(\omega)\} =$
k-Anfänge der Strings, die __hinter__ $\chi$ generiert werden können  

- Kontextfreie Grammatik ist SLL($k$) gdw. für alle Produktionen eines Nichtterminals $A \to \alpha$ die Mengen $\text{First}_k(\alpha \text{Follow}_k(A))$ (**Indizmengen**) unterschiedlich sind.
  - $k = 1, \alpha \not\Rightarrow^* \varepsilon, \beta \not\Rightarrow^* \varepsilon$: genügt, wenn $\text{First}(\alpha) \cap \text{First}(\beta) = \emptyset$
  - $k = 1, \alpha     \Rightarrow^* \varepsilon, \beta \not\Rightarrow^* \varepsilon$: genügt, wenn $\text{Follow}(A)     \cap \text{First}(\beta) = \emptyset$
- Linksrekursive kontextfreie Grammatiken sind für kein $k$ SLL($k$).
- Für jede kontextfreie Grammatik $G$ mit linksrekursiven Produktionen gibt es eine kontextfreie Grammatik $G'$ ohne Linksrekursion mit $L(G) = L(G')$
- Nutze $\{T \to F \mid T * F\} \leadsto \{T \to F\ \ T\!List,\ T\!List \to \varepsilon \mid *\ \ F\ \ T\!List\}$ und Linksfaktorisierung

### Recursive Decent

\Begin{multicols}{2}
Eine `parse`-Funktion pro Nichtterminal, konsumieren ihren Teil der Eingabe.
Erzeugt automatisch Linksableitung.

```java
void main() {
  lexer.lex(); // lexer.current ist nun das 1. Token
  Expr ast = parseE(); // E ist das Startsymbol
}
void expect(TokenType e) {
  if (lexer.current == e) lexer.lex();
  else error("Expected ", e, 
             " but got ", lexer.current);
}
Expr parseF() {
  if (lexer.current==TokenType.ID) { // F -> id
    expect(TokenType.ID) // only consume if in grammar
  } else { // F -> ( E )
    expect(TokenType.LP);
    Expr res = parseE();
    expect(TokenType.RP);
    return res
  }
}
```
\columnbreak
```java
Expr parseTList(Expr left) { // T -> F([*/]F)*
  Expr res = left;
  switch (lexer.current) {
    case STAR: // TLIST -> * F TList
      expect(TokenType.STAR);
      res = new Mult(res, parseF());
      return parseTList(res);
    case SLASH: // TList -> / F TList
      expect(TokenType.SLASH);
      res = new Div(res, parseF());
      return parseTList(res);
    case PLUS: case MINUS: case R_PAREN: case EOF:
      // TList -> epsilon
      return res;
    default:
      error("Expected one of */+-)# but got ", 
            lexer.current);
      return null;
  }
}
// Endrekursion kann man zu while-Schleife ausrollen
// Rest analog
```
\End{multicols}

<!-- Semantische Analyse scheint nicht relevant zu sein -->

## Java Bytecode

### Examples

\Begin{multicols}{2}
#### Arithmetic
```java
void calc(int x, int y) {
  int z = 4;
  z = y * z + x;
}
```
\columnbreak
```nasm
iconst_4
istore_3
iload_2
iload_3
imul
iload_1
iadd
istore_1
```
\End{multicols}

\Begin{multicols}{2}
#### Object Creation
```java
class Test {
  Test foo() {
    return new Test();
  }
}
```
\columnbreak
```nasm
Test();
    aload_0
    invokespecial #1;
    return
Test foo();
    new #2;
    dup
    invokespecial #3;
    areturn
```
\End{multicols}

\pagebreak
\Begin{multicols}{2}
#### Fields
```java
class Foo {
  public Bar field;
  public void setNull() {
    field = null;
  }
}
```
\columnbreak
```nasm
setNull();
  aload 0 ; Parameter 0 (this) auf Stack
  aconst null ; null auf den Stack
  putfield Foo.field:LBar; ; Schreibe Wert (null)
  ; in Feld Foo.field von Objekt (this)
  return
```
\End{multicols}

#### Loops

`while`-Loop: `loop:`, condition, conditional jump to `afterLoop`, body, `goto loop`, `afterLoop:`  
`if`-$\mathfrak{Loop}$: condition, conditional jump to `then`, `goto else`, then, `goto afterIf`, else,`afterIf:`  (shortcircuiting!)

\Begin{multicols}{2}
#### Method Call
```java
foo(42)
```
\columnbreak
```nasm
aload_0 ; load this
bipush 42 ; load aruments 
invokevirtual #2
; return value is on stack
```
\End{multicols}

### General

```nasm
; types are labeled by their first letter
int, long, short, byte=boolean, char, float, double, a -> reference

; always push left argument first and then right argument!

```
\Begin{multicols}{2}
```nasm
; load constants on the stack
aconst_null ; null object
dconst_0, donst_1 ; double value 0/1
fconst_0, fconst_1, fconst_2 ; float value 0/1/2
iconst_0 ... iconst_5 ; integer values 0 .. 5
iconst_m1 ; integer value -1

; push immediates
bipush i ; push signed byte i on the stack
sipush i ; push signed short i on the stack

; load/store variable with index i of type X
Xload_i ; for i in [0, 3] to save a few bytes
Xload i ; load local variable i (is a number)
Xstore i ; store local variable i

; Methods
invokevirtual #2; call function, #2 -> Konstantenpool
return ; return void
Xreturn ; return value of type X

; Jumps
goto label ; unconditionally jump to label

; 2-conditional: pop and look (secondtop ? top)
; for ints, all take a label:
if_icmpeq, if_icmpne
if_icmpge, if_icmpgt, if_icmple, if_icmplt
if_acmpeq label ; jump if refs are equal
if_acmpne label ; jump if refs are different

; 1-conditional: pop and compare top with 0
; for ints, all take a label:
ifeq, ifge, ifgt, iflt, ifle, ifne
ifnull label ; jump if reference is null
ifnonnull label ; jump if reference is not null
```
\columnbreak
```nasm
; Arithmetic
iinc i const ; increment int variable i by const
iadd ; Integer addition
isub ; Integer subtraction (secondtop - top)
imul ; Integer multiplication
idiv ; Integer division (secondtop / top)
irem ; Integer modulo (secondtop % top)
ineg ; negate int
ishl ; shift left (secondtop >> top)
ishr ; shift right (secondtop << top)

; Logic (i in [i, l])
iand ; Bitwise and
ior ; Bitwise or
ixor ; Bitwise or

; Method calls. Stack: [objref, arg1, arg2] <‐
invokevirtual #desc ; call method specified in desc
invokespecial #desc ; call constructor
invokeinterface #desc ; call method on interface
invokestatic #desc ; call static method (no objref)

; Misc
nop ; No operation

; Arrays
newarray T ; new array of type T
Xaload ; load type X from array [arr, index] -> [value]
Xastore ; store type X in array [arr, index, val] -> []
arraylength ; length of array
```
\End{multicols}

