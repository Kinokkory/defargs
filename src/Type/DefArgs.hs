{-# LANGUAGE
    Trustworthy,
    TypeOperators, ScopedTypeVariables, TypeFamilies,
    ConstraintKinds, DataKinds,
    MultiParamTypeClasses, FlexibleContexts, FlexibleInstances, UndecidableInstances #-}

--------------------------------------------------------------------------------
-- |
-- Module: Type.DefArgs
-- Copyright: (c) Yusuke Matsushita 2014
-- License: BSD3
-- Maintainer: Yusuke Matsushita
-- Stability: provisional
-- Portability: portable
--
-- Default arguments in Haskell.
--------------------------------------------------------------------------------

module Type.DefArgs (
    -- * Example
    -- $example

    -- * Def
    Def(..)

    -- * Converters
    -- $converters
  , defarg, defargs2, defargs3, defargs4, defargs5
  , defargs6, defargs7, defargs8, defargs9, defargs10

    -- * Constraints
  , MightBe, type (=?)) where

import Type.Cluss

-- | When used as an argument, 'Def' will be replaced with the corresponding default value by 'defarg', 'defargs2', ..., and 'defargs10'.
data Def = Def

-- heterogeneous list
data Nil = Nil
data a * b = Cons a b
(&) :: a -> b -> a * b
(&) = Cons
infixr 0 *, &

-- core
class DefArgs' f as where
  type P f as :: [*]
  defargs' :: K f as g => f -> as -> g
type K f as = In (P f as)
instance DefArgs' r Nil where
  type P r Nil = '[Type r]
  defargs' x Nil = projI (
    x `andI`
    noneI :: AllOfI '[Type r])
instance DefArgs' f as => DefArgs' (a -> f) (a * as) where
  type P (a -> f) (a * as) = '[Binary (->) (IR1 (In [Type Def, Type a]) >|< K f as)]
  defargs' f (Cons x xs) = projI ((projF (
      (\Def -> defargs' (f x) xs) `andF`
      (\x' -> defargs' (f x') xs) `andF`
      noneF)) `andI2`
    noneI :: AllOfI (P (a -> f) (a * as)))

-- constraints
type MightBe a' a = In [Type Def, Type a] a'
type a' =? a = MightBe a' a
infixl 0 =?

-- $converters
-- Given a function, these converters provide every argument of the function with a default value.
-- 'defarg' is used for a function of one argument, 'defargs2' is used for a function of two arguments, and so on.
--
-- The converters require concrete types for the type variables @a, b, c, ...@;
-- they need concrete types in order to judge whether a type is 'Def' or non-'Def'.
-- Internally, the judgment is made by <http://hackage.haskell.org/package/cluss cluss>.

-- converters
defarg :: (a' =? a) => (a -> r) -> a -> (a' -> r)
defarg f x = defargs' f (x & Nil)
defargs2 :: (a' =? a, b' =? b) => (a -> b -> r) -> a -> b -> (a' -> b' -> r)
defargs2 f x x2 = defargs' f (x & x2 & Nil)
defargs3 :: (a' =? a, b' =? b, c' =? c) => (a -> b -> c -> r) -> a -> b -> c -> (a' -> b' -> c' -> r)
defargs3 f x x2 x3 = defargs' f (x & x2 & x3 & Nil)
defargs4 :: (a' =? a, b' =? b, c' =? c, d' =? d) => (a -> b -> c -> d -> r) -> a -> b -> c -> d -> (a' -> b' -> c' -> d' -> r)
defargs4 f x x2 x3 x4 = defargs' f (x & x2 & x3 & x4 & Nil)
defargs5 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e) => (a -> b -> c -> d -> e -> r) -> a -> b -> c -> d -> e -> (a' -> b' -> c' -> d' -> e' -> r)
defargs5 f x x2 x3 x4 x5 = defargs' f (x & x2 & x3 & x4 & x5 & Nil)
defargs6 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e, f' =? f) => (a -> b -> c -> d -> e -> f -> r) -> a -> b -> c -> d -> e -> f -> (a' -> b' -> c' -> d' -> e' -> f' -> r)
defargs6 f x x2 x3 x4 x5 x6 = defargs' f (x & x2 & x3 & x4 & x5 & x6 & Nil)
defargs7 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e, f' =? f, g' =? g) => (a -> b -> c -> d -> e -> f -> g -> r) -> a -> b -> c -> d -> e -> f -> g -> (a' -> b' -> c' -> d' -> e' -> f' -> g' -> r)
defargs7 f x x2 x3 x4 x5 x6 x7 = defargs' f (x & x2 & x3 & x4 & x5 & x6 & x7 & Nil)
defargs8 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e, f' =? f, g' =? g, h' =? h) => (a -> b -> c -> d -> e -> f -> g -> h -> r) -> a -> b -> c -> d -> e -> f -> g -> h -> (a' -> b' -> c' -> d' -> e' -> f' -> g' -> h' -> r)
defargs8 f x x2 x3 x4 x5 x6 x7 x8 = defargs' f (x & x2 & x3 & x4 & x5 & x6 & x7 & x8 & Nil)
defargs9 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e, f' =? f, g' =? g, h' =? h, i' =? i) => (a -> b -> c -> d -> e -> f -> g -> h -> i -> r) -> a -> b -> c -> d -> e -> f -> g -> h -> i -> (a' -> b' -> c' -> d' -> e' -> f' -> g' -> h' -> i' -> r)
defargs9 f x x2 x3 x4 x5 x6 x7 x8 x9 = defargs' f (x & x2 & x3 & x4 & x5 & x6 & x7 & x8 & x9 & Nil)
defargs10 :: (a' =? a, b' =? b, c' =? c, d' =? d, e' =? e, f' =? f, g' =? g, h' =? h, i' =? i, j' =? j) => (a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> r) -> a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> (a' -> b' -> c' -> d' -> e' -> f' -> g' -> h' -> i' -> j' -> r)
defargs10 f x x2 x3 x4 x5 x6 x7 x8 x9 x10 = defargs' f (x & x2 & x3 & x4 & x5 & x6 & x7 & x8 & x9 & x10 & Nil)

-- $example
-- Here is a simple example.
--
-- >{-# LANGUAGE TypeOperators, FlexibleContexts #-}
-- >
-- >import Type.DefArgs
-- >
-- >test :: (s =? String, s' =? String) => s -> s' -> String
-- >test = defargs2 (\x y -> x ++ ", " ++ y ++ "!") "hello" "world"
-- >
-- >test2 :: (i =? Int, i' =? Int) => i -> i' -> Int
-- >test2 = defargs2 (+) (10 :: Int) 100
-- >
-- >main = do
-- >  putStrLn $ test Def Def
-- >  putStrLn $ test "good morning" Def
-- >  putStrLn $ test Def "kitty"
-- >  putStrLn $ test "oh" "yeah"
-- >  print $ test2 (90 :: Int) Def
--
-- This is the result.
--
-- >hello, world!
-- >good morning, world!
-- >hello, kitty!
-- >oh, yeah!
-- >190
