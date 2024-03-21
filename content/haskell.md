# Haskell

\Begin{multicols}{2}

Referenzielle Transparenz:
Im gleichen Gültigkeitsbereich bedeuten gleiche Ausdrücke stets das
gleiche. Zwei verschiedene Ausdrücke, die zum gleichen Wert auswerten,
können stets durch den anderen ersetzt werden, ohne die Bedeutung des
Programms zu verändern.

## General Haskell stuff
```haskell
-- type definitions are right associative
foo :: a  -> b  -> c  -> d
foo :: (a -> (b -> (c -> d)))
-- function applications are left associative
foo a b c d
((((foo a) b) c) d)
-- prefix notation takes precedence over infix notation
id' l = head l : tail l

-- pattern matching can use constructors and constants
head (x:x2:xs) = x
only [x] = x
first (Pair a b) = a
first (a, b) = a
response "hello" = "world"

-- alias for pattern matching
foo l@(x:xs) = l == (x:xs) -- returns true

-- guards
foo x y
  | x > y = "bigger"
  | x < y = "smaller"
  | x == y = "equal"
  | otherwise = "love"

-- case of does pattern matching
foo x = case x of
          [] -> "salad"
          [1] -> "apple"
          (420:l) -> "pear"

-- list comprehension
[foo x | x <- [1..420], x `mod` 2 == 0]

[0..5] == [0,1,2,3,4,5]

-- combine two functions
f :: a -> b
g :: b -> c

h :: a -> c
h = f . g

-- type alias
type Car = (String,Int)

-- data types
data Tree a = Leaf
              | Node (Tree a) a (Tree a)
              deriving (Show)

-- defines interfac
class Eq t where
  (==) :: t -> t -> Bool
  (/=) :: t -> t -> Bool
  -- default implementation
  x /= y = not $ x == y

class Coll c where
  contains :: (Ord t) =>
  (c t) -> t -> Bool

-- extends interface
class (Show t) => B t where
  foo :: (B t) -> String

-- implement interface
instance Eq Bool where
  True == True = True
  False == False = True
  True == False = False
  False == True = False
```

\End{multicols}

## Idioms

```haskell
-- backtracking
backtrack :: Conf -> [Conf]
backtrack conf
  | solution conf = [conf]
  | otherwise = concat (map backtrack (filter legal (successors conf)))

solutions = backtrack initial

-- accumulator
-- linear recursion = only one recursive branch per call
-- end recursion = linear recursion + nothing to do with the result after recursive call
-- end recursion makes things memory efficient
fak n = fakAcc n 1
  where fakAcc n acc = if (n==0) then acc else fakAcc (n-1) (n*acc)
-- end of where is determined by indentation!
```

## Important functions

See extra Cheat Sheet: https://github.com/rudymatela/concise-cheat-sheets

`foldr` can handle infinite lists (streams) if combinator does sometimes not depend on right rest. `foldl` cannot.
Result is a list => probably want to use foldr

Additional functions (maybe handwrite on other cheatsheet):
```haskell
-- in a list of type [(key, value)]  returns first element where key matches given value
lookup :: Eq a => a -> [(a, b)] -> Maybe b
-- applies function until the predicate is true
until :: (a -> Bool) -> (a -> a) -> a -> a
-- returns true if the predicate is true for at least one element
any :: Foldable t => (a -> Bool) -> t a -> Bool
-- return true if the predicate is true for all elements
all :: Foldable t => (a -> Bool) -> t a -> Bool
-- reverse list
reverse = foldl (flip (:)) []
```
