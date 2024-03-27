\newpage

# Java

## Functional programming

\vspace{-2em}
\Begin{multicols}{2}
```java

@FunctionalInterface
interface Predicate {
  boolean check(int value);
}

// lambda
(int i, int j) -> i + j;
// method reference to static function
SomeClass::staticFunction;
// method reference to object function
someObject::function;
```
\End{multicols}

\vspace{-2em}
## Streams

Use `Collection.stream()` or `Collection.parallelStream()` to obtain a stream.  
Methods: `filter`, `map`, `mapToInt`, `reduce`, `findAny`, `findFirst`, `min`, `max`, `average`, `limit`, `skip`, `distinct`, `sorted`, `toList`

```java
personsInAuditorum.stream().collect(
  () -> 0, // supplier of neutral value
  (currentSum, person) -> { currentSum += person.getAge(); } // accumulator of acc and elem
  (leftSum, rightSum) -> { leftSum += rightSum; } // combiner of multiple accs (for parallel)
);
```

## Multithreading
### Race conditions
A race condition exists if the order in which threads execute their operations influences the result of the program.  
Are precluded by synchronization and by atomicity.

### Mutual Exclusion
A code section that only one thread is allowed to execute at a time is called a critical section.
If one thread executes operations of a critical section, other threads will be blocked if they want to enter it as well.
$\Rightarrow$ only one thread per monitor is allowed to be in the section, but it may be multiple times (recursion).
Test using `Thread.holdsLock(Object obj)`.

\Begin{multicols}{2}
```java
// synchronized block, someObject is used as monitor
synchronized(someObject) {
  ...
}
// synchronized method, this is used as monitor
synchronized void foo() {
  ...
}
```
\End{multicols}

### Deadlock

A deadlock can occur iff all Coffman conditions hold:

- Mutual exclusion: unshareable resources (given in Java)
- Hold and wait: a thread holds a resrouce and requests access to another one
- No preemption: resources can only be released by their holder (given in Java)
- Circular wait: circular dependency between thread that all hold and request a resource

### `wait` and `notify`

```java
// put this thread to sleep (always use in while loop!)
public final void wait() throws InterruptedException;
// put this thread to sleep, be ready again in timeout milliseconds
public final void wait(long timeout) throws InterruptedException;
// make ANY other sleeping thread ready (never use!)
public final void notify();
// make ALL other sleeping threads ready
public final void notifyAll();
// interrupt thread (signal is not lost, if it is not currently waiting)
Thread t;
t.interrupt();
// make sure to catch InterruptedException and cease work in that thread!
```

<!-- ### Java Thread Lifecycle
![](image.png){ width=50% } -->

### Happens-before Relation

If t1 "happens before" t2, it is guaranteed that potential side effects of t1 are visible to t2.  
This is a partial order and thus transitive!

Rules that create "happens-before"-relationship:

- same thread + data dependency
- statements in parent thread before `Thread.start` -> statements in the thread
- statements in the thread -> statements in the parent thread after `Thread.join`
- between synchronized blocks of the same monitor
- write to a volatile variable -> every subsequent read to that variable

#### `volatile`
\Begin{multicols}{2}
- ensures that changes to variables are immediately visible to all threads/processors
- establishes a happens-before relationship
- values are not locally cached in a CPU cache
- no optimization by compiler

\columnbreak
```java
// declare a volatile variable
volatile int c = 420;
```
\End{multicols}

### Executors

- Executors abstract from thread creation
- provide method `execute` that runs a `Runnable` in a thread according to strategy
- `ExecutorService` is an interface that provides further lifecycle management logic (e.g. `Future`s):

```java
ExecutorService executor = Executors.newCachedThreadPool();
Callable<Integer> myCallable = () -> { return 42; };
Future<Integer> myFuture = executor.submit(myCallable);
int x = myFuture.get();
int x = myFuture.get(1, TimeUnit.SECONDS); // may throw TimeoutException
CompletableFuture<Integer> cFuture = CompletableFuture.supplyAsync(() -> ...);
CompletableFuture<...> transformed = cFuture.thenApply((Integer res) -> ...).thenApply(...);
```

### Atomic

\Begin{multicols}{2}
Atomic operations are either executed completely or not at all. Atomic operations:

- reads and writes of reference variables
- reads and writes of 32-bit primitives
- reads and writes of all variables using `volatile`
- NOT: `i++`, `x=y+1`

\columnbreak
```java
class AtomicInteger {
  int get()
  int incrementAndGet()
  int decrementAndGet()
  boolean compareAndSet(int oldValue, int newValue)
  // more like tryReplace, result iff successful
}
```
\End{multicols}

<!-- Akka is not relevant this year -->

## Design by Contract
Form of a Hoare triple $\{P\}\ C\ \{Q\}$

- $P$: precondition $\rightarrow$ specification what the supplier can expect from the client
- $C$: series of statements $\rightarrow$ the method of body
- $Q$: postcondition $\rightarrow$ specification of what the client can expect from the supplier if the precondition is fulfilled
- **Non-Redundancy-Principle:** the body of a routine shall not test for the routine's precondition
- **Precondition Availability:** precondition should be understandable by every client
- **Assertion Violation Rule:** a runtime assertion violation is the manifestation of a bug in the software
- **Liskov Substitution Principle**
  - Along specialization: guarantees may strengthen, requirements may weaken
  - $\texttt{Precondition}_{Super} \Rightarrow \texttt{Precondition}_{Sub}, 
    \texttt{Postcondition}_{Sub} \Rightarrow \texttt{Postcondition}_{Super}, 
    \texttt{Invariants}_{Sub} \Rightarrow \texttt{Invariants}_{Super}$

\pagebreak
```java
class Stack {
  //@ invariant size >= 0
  /*@ requires size > 0;
    @ ensures size == \old(size) - 1;
    @ ensures \result == \old(top());
    @ ensures (\forall int i; 0 <= i && i < size; \old(elements[i]) == elements[i]);
    @ assignable size; // redundant
    @ signals (IllegalOperationException ioEx) size == 0; // redundant
    @*/
  Object pop() { ... }

  // also: ==>, <==>, <=!=>, \exists, @ pure
  /*@ nullable @*/ /*@ pure @*/ Object top() { ... }
}
```

