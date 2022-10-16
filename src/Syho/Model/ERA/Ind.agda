--------------------------------------------------------------------------------
-- Exclusive & persistent indirection ERAs
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Syho.Model.ERA.Ind where

open import Base.Level using (1ᴸ)
open import Base.Func using (_▷_)
open import Base.Few using (⊤₀; absurd)
open import Base.Eq using (_≡_; refl)
open import Base.Dec using (yes; no; _≟_; ≟-refl; upd˙)
open import Base.Option using (¿_; š_; ň)
open import Base.Prod using (_×_; π₀; π₁; _,_; -,_; _,-)
open import Base.Sum using (ĩ₀_; ĩ₁_)
open import Base.Nat using (ℕ; ṡ_; _≥_; _<_; <⇒≤; ≤-refl; <-irrefl; _<≥_; ∀≥;
  ∀≥-upd˙-sat; ∀≥-upd˙-ṡ)
open import Base.List using ([_])
open import Syho.Logic.Prop using (Prop∞; ⊤')
open import Syho.Model.ERA.Base using (ERA; Envmᴱᴿᴬ; Envvᴱᴿᴬ)
open import Syho.Model.ERA.Exc using (Excᴱᴿᴬ; #ˣ_; ✓ˣ-new; ✓ˣ-agree; ✓ˣ-free)
open import Syho.Model.ERA.Ag using (Agᴱᴿᴬ; ✓ᴸ-[]; ✓ᴸ-new; ✓ᴸ-agree)
import Syho.Model.ERA.All

private variable
  P :  Prop∞
  Qˇ˙ :  ℕ → ¿ Prop∞
  i n :  ℕ

--------------------------------------------------------------------------------
-- Indˣᴱᴿᴬ :  Exclusive indirection ERA

module AllIndˣ =  Syho.Model.ERA.All ℕ (λ _ → Excᴱᴿᴬ Prop∞)
open AllIndˣ public using () renaming (
  --  ∀Indˣᴱᴿᴬ :  ERA 1ᴸ 1ᴸ 1ᴸ 1ᴸ
  ∀ᴱᴿᴬ to ∀Indˣᴱᴿᴬ;
  inj˙ to inj˙ᴵⁿᵈˣ)

Indˣᴱᴿᴬ :  ERA 1ᴸ 1ᴸ 1ᴸ 1ᴸ
Indˣᴱᴿᴬ =  Envvᴱᴿᴬ (Envmᴱᴿᴬ ∀Indˣᴱᴿᴬ ((ℕ → ¿ Prop∞) × ℕ) π₀)
  -- Any index in the domain of Pˇ˙ is less than n
  λ (Pˇ˙ , n) → ∀≥ n (λ _ → _≡ ň) Pˇ˙

open ERA Indˣᴱᴿᴬ public using () renaming (Env to Envᴵⁿᵈˣ; Res to Resᴵⁿᵈˣ;
  ε to εᴵⁿᵈˣ; _✓_ to _✓ᴵⁿᵈˣ_; _↝_ to _↝ᴵⁿᵈˣ_)

-- Empty environment of Indˣᴱᴿᴬ

empᴵⁿᵈˣ :  Envᴵⁿᵈˣ
empᴵⁿᵈˣ =  (λ _ → ň) , 0

-- Exclusively own a proposition at an index

indˣ :  ℕ →  Prop∞ →  Resᴵⁿᵈˣ
indˣ i P =  inj˙ᴵⁿᵈˣ i (#ˣ P)

abstract

  -- empᴵⁿᵈˣ with εᴵⁿᵈˣ is valid

  empᴵⁿᵈˣ-✓ε :  empᴵⁿᵈˣ ✓ᴵⁿᵈˣ εᴵⁿᵈˣ
  empᴵⁿᵈˣ-✓ε =  (λ _ _ → refl) , _

  -- Add a new proposition and get a line

  indˣ-new :  ((Qˇ˙ , n) , εᴵⁿᵈˣ)  ↝ᴵⁿᵈˣ λ (_ : ⊤₀) →
                (upd˙ n (š P) Qˇ˙ , ṡ n) , indˣ n P
  indˣ-new _ _ .π₀ =  _
  indˣ-new _ (✓Qˇ ,-) .π₁ .π₀ =  ∀≥-upd˙-ṡ {F = λ _ → _≡ ň} ✓Qˇ
  indˣ-new {n = n} _ (✓Qˇ , Qˇ✓Rˣ) .π₁ .π₁ i  with i ≟ n | Qˇ✓Rˣ i
  … | no _ | Qˇi✓Rˣi =  Qˇi✓Rˣi
  … | yes refl | Qˇn✓Rˣn  rewrite ✓Qˇ _ ≤-refl =  ✓ˣ-new Qˇn✓Rˣn

  -- Remove a proposition consuming a line

  indˣ-use :  ((Qˇ˙ , n) , indˣ i P)  ↝ᴵⁿᵈˣ
                λ (_ :  Qˇ˙ i ≡ š P  ×  i < n) →  (upd˙ i ň Qˇ˙ , n) , εᴵⁿᵈˣ
  indˣ-use {n = n} {i} Rˣ˙ (✓Qˇ , Qˇ✓iP∙Rˣ) .π₀  with Qˇ✓iP∙Rˣ i
  … | Qˇi✓#P∙Rˣi  rewrite ≟-refl {a = i}  with ✓ˣ-agree {x = Rˣ˙ i} Qˇi✓#P∙Rˣi
  …   | Qˇi≡šP  with i <≥ n
  …     | ĩ₀ i<n =  Qˇi≡šP , i<n
  …     | ĩ₁ i≥n  rewrite ✓Qˇ _ i≥n =  Qˇi≡šP ▷ λ ()
  indˣ-use _ (✓Qˇ ,-) .π₁ .π₀ =  ∀≥-upd˙-sat {F = λ _ → _≡ ň} refl ✓Qˇ
  indˣ-use {i = i} _ (-, Qˇ✓iP∙Rˣ) .π₁ .π₁ j  with j ≟ i | Qˇ✓iP∙Rˣ j
  … | no _ | Qˇj✓Rˣj =  Qˇj✓Rˣj
  … | yes refl | Qˇi✓#P∙Rˣi =  ✓ˣ-free Qˇi✓#P∙Rˣi

--------------------------------------------------------------------------------
-- Indᵖᴱᴿᴬ :  Persistent indirection ERA

module AllIndᵖ =  Syho.Model.ERA.All ℕ (λ _ → Agᴱᴿᴬ Prop∞)
open AllIndᵖ public using () renaming (
  --  ∀Indᵖᴱᴿᴬ :  ERA 1ᴸ 1ᴸ 1ᴸ 1ᴸ
  ∀ᴱᴿᴬ to ∀Indᵖᴱᴿᴬ;
  inj˙ to inj˙ᴵⁿᵈᵖ)

Indᵖᴱᴿᴬ :  ERA 1ᴸ 1ᴸ 1ᴸ 1ᴸ
Indᵖᴱᴿᴬ =  Envvᴱᴿᴬ (Envmᴱᴿᴬ ∀Indᵖᴱᴿᴬ ((ℕ → ¿ Prop∞) × ℕ) π₀)
  -- Any index in the domain of Pˇ˙ is less than n
  λ (Pˇ˙ , n) → ∀≥ n (λ _ → _≡ ň) Pˇ˙

open ERA Indᵖᴱᴿᴬ public using () renaming (Env to Envᴵⁿᵈᵖ; Res to Resᴵⁿᵈᵖ;
  _✓_ to _✓ᴵⁿᵈᵖ_; ε to εᴵⁿᵈᵖ; _↝_ to _↝ᴵⁿᵈᵖ_)

-- Empty environment of Indᵖᴱᴿᴬ

empᴵⁿᵈᵖ :  Envᴵⁿᵈᵖ
empᴵⁿᵈᵖ =  (λ _ → ň) , 0

-- Persistently own a proposition at an index

indᵖ :  ℕ →  Prop∞ →  Resᴵⁿᵈᵖ
indᵖ i P =  inj˙ᴵⁿᵈᵖ i [ P ]

abstract

  -- empᴵⁿᵈᵖ is valid

  empᴵⁿᵈᵖ-✓ε :  empᴵⁿᵈᵖ ✓ᴵⁿᵈᵖ εᴵⁿᵈᵖ
  empᴵⁿᵈᵖ-✓ε =  (λ _ _ → refl) , λ _ → ✓ᴸ-[]

  -- Add a new proposition and get a line

  indᵖ-new :  ((Qˇ˙ , n) , εᴵⁿᵈᵖ)  ↝ᴵⁿᵈᵖ λ (_ : ⊤₀) →
                (upd˙ n (š P) Qˇ˙ , ṡ n) , indᵖ n P
  indᵖ-new _ _ .π₀ =  _
  indᵖ-new _ (✓Qˇ ,-) .π₁ .π₀ =  ∀≥-upd˙-ṡ {F = λ _ → _≡ ň} ✓Qˇ
  indᵖ-new {n = n} _ (✓Qˇ , Qˇ✓Rs) .π₁ .π₁ i  with i ≟ n | Qˇ✓Rs i
  … | no _ | Qˇi✓Rsi =  Qˇi✓Rsi
  … | yes refl | Qˇn✓Rsn  rewrite ✓Qˇ _ ≤-refl =  ✓ᴸ-new Qˇn✓Rsn

  -- Get an agreement from a line

  indᵖ-use :  ((Qˇ˙ , n) , indᵖ i P)  ↝ᴵⁿᵈᵖ
                λ (_ :  Qˇ˙ i ≡ š P  ×  i < n) →  (Qˇ˙ , n) , indᵖ i P
  indᵖ-use _ ✓Qˇ✓iP⧺Rs .π₁ =  ✓Qˇ✓iP⧺Rs
  indᵖ-use {n = n} {i} _ (✓Qˇ , Qˇ✓iP⧺Rs) .π₀  with Qˇ✓iP⧺Rs i
  … | Qˇi✓P∷Rsi  rewrite ≟-refl {a = i}  with ✓ᴸ-agree Qˇi✓P∷Rsi
  …   | Qˇi≡šP  with i <≥ n
  …     | ĩ₀ i<n =  Qˇi≡šP , i<n
  …     | ĩ₁ i≥n  rewrite ✓Qˇ _ i≥n =  Qˇi≡šP ▷ λ ()

--------------------------------------------------------------------------------
-- On both indirection ERAs

Envᴵⁿᵈ :  Set₁
Envᴵⁿᵈ =  Envᴵⁿᵈˣ × Envᴵⁿᵈᵖ
