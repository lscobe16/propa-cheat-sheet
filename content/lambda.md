\newpage
# Lambda Calculus

\Begin{multicols}{2}

## General stuff
- Function application is left associative $\lambda x.\ f\ x\ y = \lambda x.\ ((f\ x)\ y)$
- untyped lambda calculus is turing complete

### Common Functions

- let $x = t_1$ in $t_2$ wird zu $(\lambda x.\,t_2)\,t_1$
- Rekursion: $Y = \lambda f.\,(\lambda x.\,f\ (x\ x))\ (\lambda x.\,f\ (x\ x))$

#### Church Numbers
- $c_0 = \lambda s.\,\lambda z.z$
- $c_1 = \lambda s.\,\lambda z.s\,z$
- $c_2 = \lambda s.\,\lambda z.s\,(s\,z)$
- $c_3 = \lambda s.\,\lambda z.s\,(s\,(s\,z))$
- etc...
- **Successor Function**
    - $succ\,c_2=c_3$
    - $succ = \lambda n.\,\lambda s.\,\lambda z.\, s\ (n\ s\ z)$
    - $pred$
- **Arithmetic Operations**
    - $plus = \lambda m.\,\lambda n.\,\lambda s.\,\lambda z.\,m\ s\ (n\ s\ z)$
    - $minus = \lambda m.\,\lambda n.\,n pred m$
    - $times = \lambda m.\,\lambda n.\,\lambda s.\,n\ (m\ s)$
    - $exp = \lambda m.\,\lambda n.\,n\ m$
- $isZero = \lambda n.\,n\ (\lambda x.\,c_{false})\ c_{true}$

#### Boolean Values
- $\ c_{true} = \lambda t.\ \lambda f.\ t$
- $\ c_{false} = \lambda t.\ \lambda f.\,f$
- $not = \lambda a.\, a\ c_{false}\ c_{true}$
- $and = \lambda a.\,\lambda b.\,a\ b\ a$
- $or = \lambda a.\,\lambda b.\,a\ a\ b$
- $xor = \lambda a.\,\lambda b.\,a\ (not\ b)\ b$
- $if = \lambda a.\,\lambda then.\,\lambda else.\,a\ then\ else$

## Equivalences

### $\alpha$-equivalence (Renaming)
Two terms $t_1$ and $t_2$ are $\alpha$-equivalent $t_1 \stackrel{\alpha}{=} t_2$ if $t_1$ and $t_2$ can be transformed into each other just by consistent (no collision) renaming of the bound variables. Example: $\lambda x. x \stackrel{\alpha}{=} \lambda y. y$

### $\eta$-equivalence (End Parameters)
Two terms $\lambda x. f \ x$ and $f$ are $\eta$-equivalent $\lambda x. f \ x \stackrel{\eta}{=} f$
if $x$ is not a free variable of $f$. Example: $\lambda x.f\ a\ b\ x \stackrel{\eta}{=} f\ a\ b$

## Reductions

### $\beta$-reduction
A $\lambda$-term of the shape $(\lambda x.\,t_1)\ t_2$ is called a Redex. The $\beta$-reduction is the evaluation of a function application on a redex. (Don't forget to add parenthesis!)
$$
(\lambda x.\, t_1)\ t_2 \Rightarrow t_1\,[x \mapsto t_2]
$$

A term that can no longer be reduced is called **Normal Form**. 
The Normal Form is unique. 
Terms that don't get reduced to Normal Form most often diverge (grow infinitely large).
Example: $(\lambda x.\,x\ x)\ (\lambda x.\,x\ x)$

**Full $\beta$-Reduction**: Every Redex can be reduced at any time.

**Normal Order**: The leftmost Redex gets reduced.

**Call by Name (CBN)**: Reduce the leftmost Redex *if* not surrounded by a lambda.
Example: 
\begin{align*}
&(\lambda \textcolor{green}{y}.\ (\lambda x.\ \textcolor{green}{y}\ (\lambda z.\ z)\ x))\ \textcolor{red}{((\lambda x.\ x)\ (\lambda y.\ y))} \\
\Rightarrow &(\lambda x.\ ((\lambda \textcolor{green}{x.\ x})\ \textcolor{red}{(\lambda y.\ y)})\ (\lambda z.\ z)\ x) \nRightarrow
\end{align*}


**Call by Value (CBV)**: Reduce the leftmost Redex *that is* not surrounded by a lambda and whose argument is a value. 
A value is a term that can not be further reduced.
Example:
\begin{align*}
&(\lambda y.\ (\lambda x.\ y\ (\lambda z.\ z)\ x))\ ((\lambda \textcolor{green}{x.\ x})\ \textcolor{red}{(\lambda y.\ y)}) \\
\Rightarrow &(\lambda \textcolor{green}{y}.\ (\lambda x.\ \textcolor{green}{y}\ (\lambda z.\ z)\ x))\ \textcolor{red}{(\lambda y.\ y)} \\
\Rightarrow &(\lambda x.\ (\lambda \textcolor{green}{y}.\ \textcolor{green}{y})\ \textcolor{red}{(\lambda z.\ z)}\ x) \nRightarrow
\end{align*}

Call by Name and Call by Value may not reduce to the Normal Form! Call by Name terminates more often than Call by Value.

### Church-Rosser
The untyped $\lambda$ is confluent: If $t \stackrel{*}{\Rightarrow} t_1$ and $t \stackrel{*}{\Rightarrow} t_2$ then there exists a $t'$ with $t_1 \stackrel{*}{\Rightarrow} t'$ and $t_2 \stackrel{*}{\Rightarrow} t'$.

### Recursion
Rekursive Funktion = Fixpunkt des Funktionals

$Y = \lambda f.\,(\lambda x.\,f\,(x\,x))\,(\lambda x.\,f\,(x\,x))$ is called the recursion operator.
$Y\ G$ is the fixpoint of $G$.

\End{multicols}
\newpage

