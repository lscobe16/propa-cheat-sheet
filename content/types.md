# Typen

\Begin{multicols}{2}

## Regelsysteme
- Term $\psi$ herleitbar: "$\vdash \psi$"
- Frege'scher Schlussstrich: aus dem über dem Strich kann man das unter dem Strich herleiten
- Prädikatenlogik erster Stufe:

![](image-1.png)

- Beweiskontext: $\Gamma \vdash \phi$
    - $\phi$ unter Annahme von $\Gamma$ herleitbar
    - Erleichtert Herleitung von $\phi \Rightarrow \psi$
    - Assumption Introduktion $\frac{}{\Gamma ,\phi \; \vdash \phi}$

## Typsysteme
- Einfache Typisierung
    - $\vdash (\lambda x.\, 2) : bool \rightarrow int$
    - $\vdash (\lambda x.\, 2) : int \rightarrow int$
    - $\vdash (\lambda f.\, 2) : (int \rightarrow int) \rightarrow int$
- Polymorphe Typen
    - $\vdash (\lambda x.\, 2) : \alpha \rightarrow int$
      ($\alpha$ ist implizit allquantifiziert)
- Nicht alle sicheren Programme sind typisierbar
    - Typisierbare $\lambda$-Terme (ohne \textbf{\texttt{define}}) haben Normalform $\Rightarrow$ terminieren $\Rightarrow$ sind nicht turing-mächtig
    - Typsystem nicht vollständig bzgl. $\beta$-Reduktion
        - insb. Selbstapplikation im Allgemeinen nicht typisierbar
        - damit auch nicht Y-Kombinator

### Regeln
- "$\Gamma \vdash t : \tau$": im Typkontext $\Gamma$ hat Term $t$ den Typ $\tau$
- $\Gamma$ ordnet freien Variablen $x$ ihren Typ $\Gamma(x)$ zu

\let\oldColumnsep\columnsep
\setlength{\columnsep}{-0.5cm}
\Begin{multicols}{2}
$$
\textsc{Const}\;\;\frac{c \, \in \, Const}{\Gamma \, \vdash \,  c \, : \, \tau_{c}}
$$
$$
\textsc{Var}\;\;\frac{\Gamma (x) \, = \, \tau}{\Gamma \, \vdash \, x \, : \, \tau}
$$
$$
\textsc{Abs}\;\;\frac{\Gamma , x \, : \, \tau_1 \, \vdash \, t \, : \, \tau_2}{\Gamma \, \vdash \, \lambda x.\, t :\, \tau_1 \, \rightarrow \, \tau_2}
$$
$$
\textsc{App}\;\;\frac{\Gamma \, \vdash \, t_1 \, : \, \tau_2 \rightarrow \tau \, \, \, \, \, \, \, \, \Gamma \, \vdash \, t_2 \, : \, \tau_2}{\Gamma \, \vdash \, t_1 \, \, t_2 \, : \, \tau}
$$
\End{multicols}
\let\columnsep\oldColumnsep

\columnbreak

### Typschema
- "$\forall \alpha_1. \dots \forall \alpha_n.\tau$" heißt *Typschema* (Kürzel $\phi$)
    - Es bindet freie Typvariablen $\alpha_1, \dots, \alpha_n$ in $\tau$
- \textsc{Var}-Regel muss angepasst werden:
$$
\textsc{Var}\;\;\frac{\Gamma(x) = \phi \; \; \; \; \; \phi \succeq \tau}{\Gamma \, \vdash \, x \, : \, \tau}
$$
- Neu:
$$
\textsc{Let}\;\;\frac{\Gamma \, \vdash \,t_1 \, : \, \tau_1 \; \; \; \; \; \Gamma , x \, : \, ta\,(\tau_1, \, \Gamma) \, \vdash \, t_2 \, : \, \tau_2}{\Gamma \, \vdash \, \textbf{\texttt{let}} \; x \, = \, t_1 \; \textbf{\texttt{in}} \; t_2 \, : \tau_2}
$$
- $ta\,(\tau,\,\Gamma)$: Typabstraktion
    - Alle freien Typvariablen von $\tau$, die nicht frei in Typannahmen von $\Gamma$ vorkommen, werden allquantifiziert;
      also alle "wirklich unbekannten" (auch global)

### Typinferenz

Gegeben: Term $t$ und Typannahmen $\Gamma$  
Gesucht: Lösung $(\sigma, \tau)$, sodass $\sigma\Gamma \vdash t\;:\;\tau$

1. Erstelle Herleitungsbaum anhand syntaktischer Struktur und Typisierungsregeln; dabei:
   - verwende zunächst überall rechts von : frische Typvariablen $\alpha_i$
   - extrahiere Gleichungssystem $C$ für die $\alpha_i$ gemäß Regeln
2. Bestimme mgu $\sigma$ von $C$
3. Lösung: $(\sigma, \sigma(\alpha_1))$, wobei $\alpha_1$ erste Typvariablen für $t$

Bei \textsc{Let}:

1. Sammle Gleichungen aus linkem Teilbaum in $C_{let}$
2. Berechne $\sigma_{let}$ von $C_{let}$
3. $\Gamma' := \sigma_{let}, x: ta(\sigma_{let}(\alpha_i), \sigma_{let}(\Gamma))$
4. Benutze $\Gamma'$ im rechten Teilbaum

\End{multicols}
