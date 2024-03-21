\newpage

\makeatletter
\let\longtable\oldlt
\let\endlongtable\endoldlt
\makeatother
\onecolumn


# Parallelprogrammierung

**Uniform Memory access (UMA):** .

**Parallelismus:** Mindestens zwei Prozesse laufen gleichzeitig.

**Concurrency:** Mindestens zwei Prozesse machen Fortschritt.

Speedup:
$S(n) = \frac{T(1)}{T(n)} = \frac{\text{execution time if processed by 1 processor}}{\text{execution time if processed by n processors}}$

**Amdahls' Law:**
$S(n) = \frac{1}{(1 - p) + \frac{p}{n}}$
with $p =$ parallelizable percentage of program

**Data Parallelism:** Die gleiche Aufgabe wird parallel auf unterschiedlichen Daten ausgeführt.

**Task Parallelism:** Unterschiedliche Aufgaben werden auf den gleichen Daten ausgeführt.

## Flynn's Taxonomy

| Name | Beschreibung | Beispiel |
|------|--------------|----------|
| SISD | a single instruction stream operates on a single memory              | von Neumann Architektur |
| SIMD | one instruction is applied on homogeneous data (e.g. an array) | vector processors of early supercomputer |
| MIMD | different processors operate on different data | multi-core processors |
| MISD | multiple instructions are executed simultaneously on the same data | redundant architectures, Pipelines |

## C/C++

Deklaration vor Verwendung (insbesondere bei Hilfsfunktionen!). Deklaration != Definition.

```cpp
// Arrays vs Pointers
int arr[] = { 45, 67, 89 };
int *p;
p = arr; // p is assigned the address of the first element of arr
p = &arr[0]; // same effect as above
// p and arr are almost always interchangeable, except when using with extern and lying in one declaration
int matrix[4][4];

// always fetch from main memory; no registers, no optimization
volatile int x;
```


## MPI

### Meta
```cpp
// default communicator, i.e. the collection of all processes
MPI_Comm MPI_COMM_WORLD;

// get the number of processing nodes
int MPI_Comm_size(MPI_Comm comm, int *size);

// get the rank for the processing node, root node has rank 0
int MPI_Comm_rank(MPI_Comm comm, int *rank);

// initializes MPI
int MPI_Init(int *argc, char ***argv);
// usage in main:
MPI_Init(&argc, &args);

// Cleans up MPI (called in the end)
int MPI_Finalize();

// blocks until all processes have called it
int MPI_Barrier(MPI_Comm comm);
```

### Main Operations
```cpp
// send communication modes
MPI_Send();  // standard: implementation dependent (maybe heuristic optimizing)
MPI_Bsend(); // buffered: forced buffering, no synchronization
MPI_Ssend(); // synchronous: no buffer, forced synchronization (both sides wait for each other)
MPI_Rsend(); // ready: no buffer, no synchronization -> matching receive must already be initiated
// only one receive mode -> matches all sends

// parameters are the same for all communication modes:
int MPI_Send(void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm);
                                   MPI_INT, MPI_LONG_LONG_INT, MPI_CHAR  // data types
int MPI_Recv(void *buf, int count, MPI_Datatype datatype, 
             int source, int tag, MPI_Comm comm, MPI_Status *status);
         MPI_ANY_SOURCE  MPI_ANY_TAG   // wildcards

// simultaneous send and receive
int MPI_Sendrecv(void *sendbuf, int sendcount, MPI_Datatype sendtype, int dest, int sendtag, 
                 void *recvbuf, int recvcount, MPI_Datatype recvtype, int source, int recvtag, 
                 MPI_Comm comm, MPI_Status *status)
// use the same buffer for send and receive (in a OUT-IN fashion)
int MPI_Sendrecv_replace(void *buf, int count, MPI_Datatype datatype, int dest, int sendtag, 
                         int source, int recvtag, 
                         MPI_Comm comm, MPI_Status *status)

// blocking operations block until the buffer can be (re)used
// orthogonally, all operations have a non-blocking/immediate counterpart:
int MPI_Isend(void *buf, int count, MPI_Datatype datatype, int dest, int tag,
              MPI_Comm comm, MPI_Request* request);
int MPI_Irecv(void *buf, int count, MPI_Datatype datatype, int source, int tag, 
              MPI_Comm comm, MPI_Request* request);

// send and receive operations can be checked for completion (flag == 1 iff completed)
int MPI_Test(MPI_Request* r, int* flag, MPI_Status* s);
// blocking check
int MPI_Wait(MPI_Request* r, MPI_Status* s);


```

There is no global order on communication events, but events within the same sender-receiver pair stay in order.


### Collective Operations

```cpp
int MPI_Bcast(void* buffer, int count, MPI_Datatype t, int root, MPI_Comm comm);
```

$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
    &     &     \\
    &     &
\end{bmatrix}
\overset{Broadcast}{\rightarrow}
\begin{bmatrix}
A_0 & A_1 & A_2 \\
A_0 & A_1 & A_2 \\
A_0 & A_1 & A_2
\end{bmatrix}
$$

---

```cpp
int MPI_Scatter(void *sendbuf, int sendcount, MPI_Datatype sendtype,
                void *recvbuf, int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm)

int MPI_Gather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
               void *recvbuf, int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm)

int MPI_Scatterv(void* sendbuf, int* sendcounts, int* displacements, MPI_Datatype sendtype,
                 void* recvbuf, int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm)
```
Usually: `sendcount` = `recvcount` (here 1)  
`sendcounts[i]` = how many elements to send to proc i  
`displacements[i]` = first element to send to proc i (no overlap allowed, but gaps
$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
    &\quad&\quad\\
    &&
\end{bmatrix}
\overset{scatter}{\underset{gather}{\rightleftarrows}}
\begin{bmatrix}
A_0 & \quad & \quad \\
A_1 &       &      \\
A_2 &       &
\end{bmatrix}
$$

---


```cpp
int MPI_Allgather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
                  void *recvbuf, int recvcount, MPI_Datatype recvtype, MPI_Comm comm)
```

$$
\begin{bmatrix}
A_0 & \quad & \quad \\
B_0 &       &       \\
C_0 &       &
\end{bmatrix}
\overset{Allgather}{\rightarrow}
\begin{bmatrix}
A_0 & B_0  & C_0 \\
A_0 & B_0  & C_0 \\
A_0 & B_0  & C_0
\end{bmatrix}
$$

---

```cpp
int MPI_Alltoall(void *sendbuf, int sendcount, MPI_Datatype sendtype,
                 void *recvbuf, int recvcount, MPI_Datatype recvtype,
                 MPI_Comm comm)
```
(like matrix transposing)
$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
B_0 & B_1 & B_2 \\
C_0 & C_1 & C_2
\end{bmatrix}
\overset{Alltoall}{\rightarrow}
\begin{bmatrix}
A_0 & B_0  & C_0 \ \\
A_1 & B_1  & C_1 \ \\
A_2 & B_2  & C_2 \
\end{bmatrix}
$$

---

```cpp
int MPI_Reduce(void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
               MPI_Op op, int root, MPI_Comm comm);
```

$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
B_0 & B_1 & B_2 \\
C_0 & C_1 & C_2
\end{bmatrix}
\overset{Reduce}{\rightarrow}
\begin{bmatrix}
A_0 + B_0 + C_0 & A_1 + B_1 + C_1  & A_2 + B_2 + C_2 \\
                &                  &                 \\
                &                  &
\end{bmatrix}
$$

`op` can be:

- Logical: `MPI_LAND`, `MPI_BAND`, `MPI_LOR`, `MPI_BOR`, ...
- Arithmetic: `MPI_MAX`, `MPI_MIN`, `MPI_SUM`, `MPI_PROD`, ...
- Arg (get causing rank): `MPI_MINLOC`, `MPI_MAXLOC`

---

```cpp
int MPI_Allreduce(void *sendbuf, void *recvbuf, int count,
                  MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
```

$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
B_0 & B_1 & B_2 \\
C_0 & C_1 & C_2
\end{bmatrix}
\overset{Allreduce}{\rightarrow}
\begin{bmatrix}
A_0 + B_0 + C_0 & A_1 + B_1 + C_1  & A_2 + B_2 + C_2 \\
A_0 + B_0 + C_0 & A_1 + B_1 + C_1  & A_2 + B_2 + C_2 \\
A_0 + B_0 + C_0 & A_1 + B_1 + C_1  & A_2 + B_2 + C_2
\end{bmatrix}
$$

---

```cpp
int MPI_Reduce_scatter(void *sendbuf, void *recvbuf, int recvcounts[],
                       MPI_Datatype datatype, MPI_Op op, MPI_Comm comm)
```

$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
B_0 & B_1 & B_2 \\
C_0 & C_1 & C_2
\end{bmatrix}
\overset{Reduce-scatter}{\rightarrow}
\begin{bmatrix}
A_0 + B_0 + C_0  & \quad & \quad \\
A_1 + B_1 + C_1  &       & \\
A_2 + B_2 + C_2  &       &
\end{bmatrix}
$$

---

```cpp
int MPI_Scan(void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
             MPI_Op op, MPI_Comm comm);
```

$$
\begin{bmatrix}
A_0 & A_1 & A_2 \\
B_0 & B_1 & B_2 \\
C_0 & C_1 & C_2
\end{bmatrix}
\overset{Scan}{\rightarrow}
\begin{bmatrix}
A_0 & A_1 & A_2 \\
A_0 + B_0 & A_1 + B_1 & A_2 + B_2 \\
A_0 + B_0 + C_0 & A_1 + B_1 + C_1 & A_2 + B_2 + C_2
\end{bmatrix}
$$

