--------------------------------------------------------------------------------
-- Lists
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Base.List where

open import Base.Level using (Level)
open import Base.Eq using (_≡_; refl; cong)

--------------------------------------------------------------------------------
-- List

open import Agda.Builtin.List public using (List; []; _∷_)

private variable
  ℓ :  Level
  A B :  Set ℓ
  as bs cs :  List A

--------------------------------------------------------------------------------
-- Singleton list

[_] :  A →  List A
[ a ] =  a ∷ []

--------------------------------------------------------------------------------
-- Map

map :  (A → B) →  List A →  List B
map _ [] =  []
map f (a ∷ as) =  f a ∷ map f as

--------------------------------------------------------------------------------
-- Append

infixr 5 _++_
_++_ :  List A →  List A →  List A
[] ++ bs =  bs
(a ∷ as) ++ bs =  a ∷ (as ++ bs)

abstract

  -- ++ is associative

  ++-assocˡ :  (as ++ bs) ++ cs ≡ as ++ (bs ++ cs)
  ++-assocˡ {as = []} =  refl
  ++-assocˡ {as = _ ∷ as} =  cong (_ ∷_) (++-assocˡ {as = as})
