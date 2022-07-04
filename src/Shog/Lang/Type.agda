--------------------------------------------------------------------------------
-- Type
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

open import Base.Level using (Level)
module Shog.Lang.Type (ℓ : Level) where

open import Base.Level using (^ˡ_)

--------------------------------------------------------------------------------
-- Type:  Simple type for expressions

infixr 4 _*→*_ _→*_

data  Type :  Set (^ˡ ℓ)  where
  -- Embedding a pure type
  ⌜_⌝ᵀ :  Set ℓ →  Type
  -- Function
  _*→*_ :  Type →  Type →  Type

_→*_ :  Set ℓ →  Type →  Type
A →* T =  ⌜ A ⌝ᵀ *→* T
