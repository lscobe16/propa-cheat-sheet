# Unifikation

## Unifikator

- Gegeben: Menge $C$ von Gleichungen über Terme
- Gesucht ist eine Substitution $\sigma$, die alle Gleichungen erfüllt: **Unifikator**
    - $\sigma$ unifiziert Gleichung "$\theta = \theta'$", falls $\sigma\theta = \sigma\theta'$
    - $\sigma$ unifiziert C, falls $\forall c \in C$ gilt: $\sigma$ unifiziert c
    - Schreibweise für Substitution: $[Y \rightarrow f (a, b), D \rightarrow b, X \rightarrow g (b), Z \rightarrow b]$  
      $\rightarrow$ soll eigentlich outline von einem Dicken Pfeil sein.

- **most general unifier** ist der allgemeinste Unifikator (mit den wenigsten unnötigen Ersetzungen/Annahmen)
  - $\sigma$ ist mgu gdw. $\forall \text{ Unifikator } \gamma \ \exists \text{ Substitution } \delta : \gamma = \delta \circ \sigma$

## Robinson-Unifikationsalgorithmus: $\texttt{unify(C)} =$

$\texttt{if C == }\emptyset\ \texttt{then []}$

$\texttt{else let }\{\theta_l = \theta_r\} \uplus \texttt{C}' = \texttt{C in}$

$\;\;\;\;\texttt{if } \theta_l \texttt{ == } \theta_r\ \texttt{then unify(C')}$

$\;\;\;\;\texttt{else if }\theta_l\ \texttt{== Y and Y} \notin \texttt{FV(}\theta_r\texttt{) then unify([Y} \rightarrow \theta_r\texttt{]C')} \circ \texttt{[Y}\rightarrow \theta_r\texttt{]}$

$\;\;\;\;\texttt{else if }\theta_r\ \texttt{== Y and Y} \notin \texttt{FV(}\theta_l\texttt{) then unify([Y} \rightarrow \theta_l\texttt{]C')} \circ \texttt{[Y}\rightarrow \theta_l\texttt{]}$

$\;\;\;\;\texttt{else if } \theta_l \texttt{ == f(}\theta_l^1,...,\theta_l^n \texttt{) and } \theta_r \texttt{ == f(}\theta_r^1,...,\theta_r^n\texttt{)}$

$\;\;\;\;\;\;\;\;\texttt{then unify(C'}\cup\{\theta_l^1=\theta_r^1,...,\theta_l^n = \theta_r^n\}\texttt{)}$

$\;\;\;\;\texttt{else \textbf{fail}}$

Intuitiv:
- Nimm immer irgendeine Gleichung
  - schon gleich $\Rightarrow$ ignorieren
  - eine Seite Variable $\Rightarrow$ substituiere sie durch andere Seite
  - beide Seiten gleiches, gleichstelliges Wurzelatom $\Rightarrow$ Argumente gleichsetzen

$\texttt{unify(C)}$ terminiert und gibt **mgu** für C zurück, falls C unifizierbar, ansonsten **fail**.


## Resolution

Resolutionsregel:
$$
\frac{
    (\tau_1, \tau_2, \dots, \tau_n; \gamma) \text{ Terme plus Substitution; }\qquad
    \alpha :- \alpha_1, \dots, \alpha_k \text{ eine Regel; }\qquad
    \sigma \text{ mgu von } \alpha \text{ und } \gamma(\tau_1)
}{
    (\alpha_1, \dots, \alpha_k, \tau_2, \dots, \tau_n; \sigma \circ \gamma)
}
$$

- $\gamma$: bisherige Substitution (wird am Ende ausgegeben)
- $P \vdash \dots$ heißt herleitbar/abarbeitbar durch logisches Programm $P$
- $P \vDash \dots$ heißt logische Konsequenz logisches Programm $P$
- Resolutionsregel ist korrekt: $P \vdash \tau_1, \dots, \tau_n \Rightarrow P \vDash \tau_1, \dots, \tau_n$
- Resolutionsregel ist vollständig: $P \vDash \tau_1, \dots, \tau_n \Rightarrow P \vdash \tau_1, \dots, \tau_n$
- Prolog ist korrekt, aber nicht vollständig (wegen deterministischer Regelwahl)

