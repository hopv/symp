--------------------------------------------------------------------------------
-- Interpreting exclusive save tokens
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Shog.Model.Save.Exc where

open import Base.Size using (∞)
open import Base.Func using (_$_)
open import Base.Nat using (ℕ)
open import Shog.Logic.Prop using (Prop'; _∧_; Basic)
open import Shog.Logic.Judg using (_⊢[_]_)
open import Shog.Model.RA using (RA)
open import Shog.Model.RA.Glob using (GlobRA; Glob; module ModGlobI;
  module ModSaveˣ; module ModExcᴾ)
open ModGlobI using (injaᴬ)
open ModSaveˣ using (injaᶠᵐ)
open ModExcᴾ using (#ˣ_)
open import Shog.Model.Prop GlobRA using (Propᵒ; _⊨_; ∃₂-syntax; ∃₀-syntax;
  _∧ᵒ_; ⌜_⌝₂; Own)
open import Shog.Model.Basic using (⸨_⸩ᴮ)

--------------------------------------------------------------------------------
-- Interpreting exclusive save tokens

lineˢˣ :  ℕ →  Prop' ∞ →  Glob
lineˢˣ i P =  injaᴬ 0 $ injaᶠᵐ i $ #ˣ P

Saveˣᵒ :  Prop' ∞ →  Propᵒ
Saveˣᵒ P =  ∃₂ P' , ∃₂ Q , ∃₂ BaQ , ∃₀ i ,
  ⌜ Q ∧ P' ⊢[ ∞ ] P ⌝₂  ∧ᵒ  ⸨ Q ⸩ᴮ {{ BaQ }}  ∧ᵒ  Own (lineˢˣ i P')
