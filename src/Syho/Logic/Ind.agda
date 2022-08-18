--------------------------------------------------------------------------------
-- Proof rules on ○, ↪⇛, ↪⟨ ⟩ᴾ, and ↪⟨ ⟩ᵀ
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Syho.Logic.Ind where

open import Base.Level using (Level; ↓_)
open import Base.Size using (Size; ∞)
open import Base.Thunk using (Thunk; ¡_; !)
open import Base.Func using (_∘_; id; const; _$_)
open import Base.Nat using (ℕ; _≤ᵈ_; ≤ᵈ-refl; ≤ᵈsuc; _≤_; ≤⇒≤ᵈ)
open import Syho.Lang.Expr using (Type; Expr; Val)
open import Syho.Logic.Prop using (Prop'; Prop˂; ∀₀-syntax; _∗_; _-∗_; □_; ○_;
  _↪[_]⇛_; _↪⟨_⟩ᴾ_; _↪⟨_⟩ᵀ[_]_; Basic)
open import Syho.Logic.Core using (_⊢[_]_; _⊢[<_]_; Pers; ⊢-refl; _»_; ∗-comm;
  ∗-elimʳ; ⊤∗-intro; -∗-elim; -∗-const)
open import Syho.Logic.Supd using ([_]⇛_; _⊢[_][_]⇛_; _⊢[<_][_]⇛_; ⇒⇛; _ᵘ»_)

-- Import and re-export
open import Syho.Logic.Judg public using (○-mono; ○-eatˡ; ○-alloc; □○-alloc-rec;
  ○-use; ↪⇛-suc; ↪⇛-eatˡ⁻ˡᵘ; ↪⇛-eatˡ⁻ʳ; ↪⇛-monoʳᵘ; ↪⇛-frameˡ; ○⇒↪⇛; ↪⇛-use;
  ↪⟨⟩ᴾ-eatˡ⁻ˡᵘ; ↪⟨⟩ᴾ-eatˡ⁻ʳ; ↪⟨⟩ᴾ-monoʳᵘ; ↪⟨⟩ᴾ-frameˡ; ○⇒↪⟨⟩ᴾ; ↪⟨⟩ᴾ-use;
  ↪⟨⟩ᵀ-suc; ↪⟨⟩ᵀ-eatˡ⁻ˡᵘ; ↪⟨⟩ᵀ-eatˡ⁻ʳ; ↪⟨⟩ᵀ-monoʳᵘ; ↪⟨⟩ᵀ-frameˡ; ○⇒↪⟨⟩ᵀ;
  ↪⟨⟩ᵀ-use)

private variable
  ł :  Level
  ι :  Size
  i j :  ℕ
  T :  Type
  P Q R :  Prop' ∞
  P˂ P'˂ Q˂ Q'˂ R˂ :  Prop˂ ∞
  X :  Set ł
  x :  X
  P˂˙ Q˂˙ :  X → Prop˂ ∞
  Qᵛ :  Val T → Prop' ∞
  Q˂ᵛ Q'˂ᵛ :  Val T → Prop˂ ∞
  Q˂ᵛ˙ :  X → Val T → Prop˂ ∞
  e :  Expr ∞ T

abstract

  ------------------------------------------------------------------------------
  -- On ○

  -->  ○-mono :  P˂ .! ⊢[< ι ] Q˂ .! →  ○ P˂ ⊢[ ι ] ○ Q˂

  -->  ○-use :  ○ P˂ ⊢[ ι ][ i ]⇛ P˂ .!

  -- ○ can eat a basic proposition

  -->  ○-eatˡ :  {{Basic Q}} →  Q ∗ ○ P˂ ⊢[ ι ] ○ ¡ (Q ∗ P˂ .!)

  ○-eatʳ :  {{Basic Q}} →  ○ P˂ ∗ Q ⊢[ ι ] ○ ¡ (P˂ .! ∗ Q)
  ○-eatʳ =  ∗-comm » ○-eatˡ » ○-mono $ ¡ ∗-comm

  -- Allocate ○

  -->  ○-alloc :  P˂ .! ⊢[ ι ][ i ]⇛ ○ P˂

  -->  □○-alloc-rec :  {{Pers (P˂ .!)}} →  □ ○ P˂ -∗ P˂ .! ⊢[ ι ][ i ]⇛ □ ○ P˂

  □○-alloc :  {{Pers (P˂ .!)}} →  P˂ .! ⊢[ ι ][ i ]⇛ □ ○ P˂
  □○-alloc =  -∗-const » □○-alloc-rec

  ------------------------------------------------------------------------------
  -- On ↪⇛

  -->  ○⇒↪⇛ :  R˂ .! ∗ P˂ .! ⊢[< ι ][ i ]⇛ Q˂ .! →
  -->          ○ R˂  ⊢[ ι ]  P˂ ↪[ i ]⇛ Q˂

  -->  ↪⇛-use :  P˂ .! ∗ (P˂ ↪[ i ]⇛ Q˂)  ⊢[ ι ][ suc i ]⇛  Q˂ .!

  -- Modify ⇛ proof

  -->  ↪⇛-suc :  P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P˂ ↪[ suc i ]⇛ Q˂

  ↪⇛-≤ᵈ :  i ≤ᵈ j →  P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P˂ ↪[ j ]⇛ Q˂
  ↪⇛-≤ᵈ ≤ᵈ-refl =  ⊢-refl
  ↪⇛-≤ᵈ (≤ᵈsuc i≤ᵈj') =  ↪⇛-≤ᵈ i≤ᵈj' » ↪⇛-suc

  ↪⇛-≤ :  i ≤ j →  P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P˂ ↪[ j ]⇛ Q˂
  ↪⇛-≤ =  ↪⇛-≤ᵈ ∘ ≤⇒≤ᵈ

  -->  ↪⇛-eatˡ⁻ˡᵘ :  {{Basic R}} →  R ∗ P'˂ .! ⊢[< ι ][ i ]⇛ P˂ .! →
  -->                R ∗ (P˂ ↪[ i ]⇛ Q˂)  ⊢[ ι ]  P'˂ ↪[ i ]⇛ Q˂

  ↪⇛-monoˡᵘ :  P'˂ .! ⊢[< ι ][ i ]⇛ P˂ .! →
                 P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P'˂ ↪[ i ]⇛ Q˂
  ↪⇛-monoˡᵘ P'⊢⇛P =  ⊤∗-intro » ↪⇛-eatˡ⁻ˡᵘ λ{ .! → ∗-elimʳ » P'⊢⇛P .! }

  ↪⇛-eatˡ⁻ˡ :  {{Basic R}} →
    R ∗ (P˂ ↪[ i ]⇛ Q˂)  ⊢[ ι ]  ¡ (R -∗ P˂ .!) ↪[ i ]⇛ Q˂
  ↪⇛-eatˡ⁻ˡ =  ↪⇛-eatˡ⁻ˡᵘ λ{ .! → ⇒⇛ $ -∗-elim ⊢-refl }

  ↪⇛-monoˡ :  P'˂ .! ⊢[< ι ] P˂ .! →
              P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P'˂ ↪[ i ]⇛ Q˂
  ↪⇛-monoˡ ⊢< =  ↪⇛-monoˡᵘ λ{ .! → ⇒⇛ $ ⊢< .! }

  -->  ↪⇛-eatˡ⁻ʳ :  {{Basic R}} →
  -->    R ∗ (P˂ ↪[ i ]⇛ Q˂)  ⊢[ ι ]  P˂ ↪[ i ]⇛ ¡ (R ∗ Q˂ .!)

  -->  ↪⇛-monoʳᵘ :  Q˂ .! ⊢[< ι ][ i ]⇛ Q'˂ .! →
  -->               P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P˂ ↪[ i ]⇛ Q'˂

  ↪⇛-monoʳ :  Q˂ .! ⊢[< ι ] Q'˂ .! →
                P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  P˂ ↪[ i ]⇛ Q'˂
  ↪⇛-monoʳ ⊢< =  ↪⇛-monoʳᵘ λ{ .! → ⇒⇛ $ ⊢< .! }

  -->  ↪⇛-frameˡ :  P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]
  -->                 ¡ (R ∗ P˂ .!) ↪[ i ]⇛ ¡ (R ∗ Q˂ .!)

  ↪⇛-frameʳ :  P˂ ↪[ i ]⇛ Q˂  ⊢[ ι ]  ¡ (P˂ .! ∗ R) ↪[ i ]⇛ ¡ (Q˂ .! ∗ R)
  ↪⇛-frameʳ =  ↪⇛-frameˡ » ↪⇛-monoˡ (¡ ∗-comm) » ↪⇛-monoʳ (¡ ∗-comm)

  ------------------------------------------------------------------------------
  -- On ↪⟨ ⟩ᴾ

  -->  ○⇒↪⟨⟩ᴾ :  P˂ .! ∗ R˂ .! ⊢[< ι ]⟨ e ⟩ᴾ (λ v → Q˂ᵛ v .!) →
  -->            ○ R˂  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ

  -->  ↪⟨⟩ᴾ-use :  P˂ .! ∗ (P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ)  ⊢[ ι ]⟨ ▶ ¡ e ⟩ᴾ  λ v → Q˂ᵛ v .!

  -- Modify ⟨ ⟩ᴾ proof

  -->  ↪⟨⟩ᴾ-eatˡ⁻ˡᵘ :  {{Basic R}} →  (R ∗ P'˂ .! ⊢[< ι ][ i ]⇛ P˂ .!) →
  -->                  R ∗ (P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ)  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᴾ Q˂ᵛ

  ↪⟨⟩ᴾ-monoˡᵘ :  P'˂ .! ⊢[< ι ][ i ]⇛ P˂ .! →
                 P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᴾ Q˂ᵛ
  ↪⟨⟩ᴾ-monoˡᵘ P'⊢⇛P =  ⊤∗-intro » ↪⟨⟩ᴾ-eatˡ⁻ˡᵘ λ{ .! → ∗-elimʳ » P'⊢⇛P .! }

  ↪⟨⟩ᴾ-eatˡ⁻ˡ :  {{Basic R}} →
    R ∗ (P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ)  ⊢[ ι ]  ¡ (R -∗ P˂ .!) ↪⟨ e ⟩ᴾ Q˂ᵛ
  ↪⟨⟩ᴾ-eatˡ⁻ˡ =  ↪⟨⟩ᴾ-eatˡ⁻ˡᵘ {i = 0} λ{ .! → ⇒⇛ $ -∗-elim ⊢-refl }

  ↪⟨⟩ᴾ-monoˡ :  P'˂ .! ⊢[< ι ] P˂ .! →
                P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᴾ Q˂ᵛ
  ↪⟨⟩ᴾ-monoˡ ⊢< =  ↪⟨⟩ᴾ-monoˡᵘ {i = 0} λ{ .! → ⇒⇛ $ ⊢< .! }

  -->  ↪⟨⟩ᴾ-eatˡ⁻ʳ :  {{Basic R}} →
  -->    R ∗ (P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ)  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᴾ λ v → ¡ (R ∗ Q˂ᵛ v .!)

  -->  ↪⟨⟩ᴾ-monoʳᵘ :  (∀ v →  Q˂ᵛ v .! ⊢[< ι ][ i ]⇛ Q'˂ᵛ v .!) →
  -->                 P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᴾ Q'˂ᵛ

  ↪⟨⟩ᴾ-monoʳ :  (∀ v →  Q˂ᵛ v .! ⊢[< ι ] Q'˂ᵛ v .!) →
                P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᴾ Q'˂ᵛ
  ↪⟨⟩ᴾ-monoʳ ⊢< =  ↪⟨⟩ᴾ-monoʳᵘ {i = 0} λ{ v .! → ⇒⇛ $ ⊢< v .! }

  -->  ↪⟨⟩ᴾ-frameˡ :  P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]
  -->                   ¡ (R ∗ P˂ .!) ↪⟨ e ⟩ᴾ λ v → ¡ (R ∗ Q˂ᵛ v .!)

  ↪⟨⟩ᴾ-frameʳ :  P˂ ↪⟨ e ⟩ᴾ Q˂ᵛ  ⊢[ ι ]
                   ¡ (P˂ .! ∗ R) ↪⟨ e ⟩ᴾ λ v → ¡ (Q˂ᵛ v .! ∗ R)
  ↪⟨⟩ᴾ-frameʳ =  ↪⟨⟩ᴾ-frameˡ »
    ↪⟨⟩ᴾ-monoˡ (¡ ∗-comm) » ↪⟨⟩ᴾ-monoʳ (λ _ → ¡ ∗-comm)

  ------------------------------------------------------------------------------
  -- On ↪⟨ ⟩ᵀ

  -->  ○⇒↪⟨⟩ᵀ :  P˂ .! ∗ R˂ .! ⊢[< ι ]⟨ e ⟩ᵀ[ i ] (λ v → Q˂ᵛ v .!) →
  -->            ○ R˂  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ

  -->  ↪⟨⟩ᵀ-use :  P˂ .! ∗ (P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ)
  -->                ⊢[ ι ]⟨ ¡ e ⟩ᵀ[ suc i ]  λ v → Q˂ᵛ v .!

  -- Modify ⟨ ⟩ᵀ proof

  -->  ↪⟨⟩ᵀ-suc :  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ suc i ] Q˂ᵛ

  ↪⟨⟩ᵀ-≤ᵈ :  i ≤ᵈ j →  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ j ] Q˂ᵛ
  ↪⟨⟩ᵀ-≤ᵈ ≤ᵈ-refl =  ⊢-refl
  ↪⟨⟩ᵀ-≤ᵈ (≤ᵈsuc i≤ᵈj') =  ↪⟨⟩ᵀ-≤ᵈ i≤ᵈj' » ↪⟨⟩ᵀ-suc

  ↪⟨⟩ᵀ-≤ :  i ≤ j →  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ j ] Q˂ᵛ
  ↪⟨⟩ᵀ-≤ =  ↪⟨⟩ᵀ-≤ᵈ ∘ ≤⇒≤ᵈ

  -->  ↪⟨⟩ᵀ-eatˡ⁻ˡᵘ :  {{Basic R}} →  (R ∗ P'˂ .! ⊢[< ι ][ j ]⇛ P˂ .!) →
  -->                  R ∗ (P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ)  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ

  ↪⟨⟩ᵀ-monoˡᵘ :  P'˂ .! ⊢[< ι ][ j ]⇛ P˂ .! →
                 P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ
  ↪⟨⟩ᵀ-monoˡᵘ P'⊢⇛P =  ⊤∗-intro » ↪⟨⟩ᵀ-eatˡ⁻ˡᵘ λ{ .! → ∗-elimʳ » P'⊢⇛P .! }

  ↪⟨⟩ᵀ-eatˡ⁻ˡ :  {{Basic R}} →
    R ∗ (P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ)  ⊢[ ι ]  ¡ (R -∗ P˂ .!) ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ
  ↪⟨⟩ᵀ-eatˡ⁻ˡ =  ↪⟨⟩ᵀ-eatˡ⁻ˡᵘ {j = 0} λ{ .! → ⇒⇛ $ -∗-elim ⊢-refl }

  ↪⟨⟩ᵀ-monoˡ :  P'˂ .! ⊢[< ι ] P˂ .! →
                P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P'˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ
  ↪⟨⟩ᵀ-monoˡ ⊢< =  ↪⟨⟩ᵀ-monoˡᵘ {j = 0} λ{ .! → ⇒⇛ $ ⊢< .! }

  -->  ↪⟨⟩ᵀ-eatˡ⁻ʳ :  {{Basic R}} →  R ∗ (P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ)  ⊢[ ι ]
  -->                 P˂ ↪⟨ e ⟩ᵀ[ i ] λ v → ¡ (R ∗ Q˂ᵛ v .!)

  -->  ↪⟨⟩ᵀ-monoʳᵘ :  (∀ v →  Q˂ᵛ v .! ⊢[< ι ][ j ]⇛ Q'˂ᵛ v .!) →
  -->                 P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ i ] Q'˂ᵛ

  ↪⟨⟩ᵀ-monoʳ :  (∀ v →  Q˂ᵛ v .! ⊢[< ι ] Q'˂ᵛ v .!) →
                P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]  P˂ ↪⟨ e ⟩ᵀ[ i ] Q'˂ᵛ
  ↪⟨⟩ᵀ-monoʳ ⊢< =  ↪⟨⟩ᵀ-monoʳᵘ {j = 0} λ{ v .! → ⇒⇛ $ ⊢< v .! }

  -->  ↪⟨⟩ᵀ-frameˡ :  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]
  -->                  ¡ (R ∗ P˂ .!) ↪⟨ e ⟩ᵀ[ i ] λ v → ¡ (R ∗ Q˂ᵛ v .!)

  ↪⟨⟩ᵀ-frameʳ :  P˂ ↪⟨ e ⟩ᵀ[ i ] Q˂ᵛ  ⊢[ ι ]
                   ¡ (P˂ .! ∗ R) ↪⟨ e ⟩ᵀ[ i ] λ v → ¡ (Q˂ᵛ v .! ∗ R)
  ↪⟨⟩ᵀ-frameʳ =  ↪⟨⟩ᵀ-frameˡ »
    ↪⟨⟩ᵀ-monoˡ (¡ ∗-comm) » ↪⟨⟩ᵀ-monoʳ (λ _ → ¡ ∗-comm)
