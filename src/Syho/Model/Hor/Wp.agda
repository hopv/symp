--------------------------------------------------------------------------------
-- Semantic atomic, partial and total weakest preconditions
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Syho.Model.Hor.Wp where

open import Base.Level using (Level; _⊔ᴸ_; 1ᴸ; 3ᴸ)
open import Base.Func using (_$_; _▷_; _∘_; _›_; id)
open import Base.Few using (⊤)
open import Base.Eq using (_≡_)
open import Base.Size using (Size; Size<; !; §_)
open import Base.Option using (¿_; ň; š_; ¿-case)
open import Base.Prod using (_×_; _,_; -,_)
open import Base.Sum using (ĩ₀_; ĩ₁_)
open import Base.Sety using ()
open import Syho.Lang.Expr using (Type; ◸_; Expr∞; Val; V⇒E)
open import Syho.Lang.Ktxred using (Redex; Ktxred; Val/Ktxred; val/ktxred)
open import Syho.Lang.Reduce using (Mem; _⇐ᴿ_; _⇐ᴷᴿ_; _⇒ᴿ∑; _⇒ᴷᴿ∑)
open import Syho.Model.Prop.Base using (Propᵒ; Monoᵒ; _⊨✓_; _⊨_; ⊨_; ∀ᵒ-syntax;
  ∃ᵒ-syntax; ⊤ᵒ; ⊤ᵒ₀; ⌜_⌝ᵒ×_; ⌜_⌝ᵒ→_; _∗ᵒ'_; _∗ᵒ_; _-∗ᵒ'_; _-∗ᵒ_; Thunkᵒ;
  Shrunkᵒ; ⊨⇒⊨✓; ∀ᵒ-Mono; ∗ᵒ⇒∗ᵒ'; ∗ᵒ'⇒∗ᵒ; ∗ᵒ-Mono; ∗ᵒ-mono; ∗ᵒ-mono✓ˡ; ∗ᵒ-monoˡ;
  ∗ᵒ-monoʳ; ∗ᵒ-assocˡ; ∗ᵒ-assocʳ; ?∗ᵒ-intro; ∗ᵒ∃ᵒ-out; -∗ᵒ⇒-∗ᵒ'; -∗ᵒ'⇒-∗ᵒ;
  -∗ᵒ-Mono; -∗ᵒ-monoʳ; ⊨✓⇒⊨--∗ᵒ; -∗ᵒ-intro'; -∗ᵒ-applyʳ; -∗ᵒ-eatˡ; ◎-Mono;
  ∗ᵒThunkᵒ-out; ∗ᵒShrunkᵒ-out)
open import Syho.Model.Prop.Names using ([⊤]ᴺᵒ)
open import Syho.Model.Supd.Interp using (⟨_⟩⇛ᵒ'⟨_⟩_; ⟨_⟩⇛ᵒ⟨_⟩_; ⇛ᵒᶠ_; ⇛ᵒᶠᴺ_;
  ⇛ᵒ⇒⇛ᵒ'; ⇛ᵒ'⇒⇛ᵒ; ⇛ᵒ-Mono; ⇛ᵒᶠ-Mono; ⇛ᵒ-mono✓; ⇛ᵒ-mono; ⇛ᵒᶠ-mono✓; ⇛ᵒᶠ-mono;
  ⊨✓⇒⊨-⇛ᵒ; ⇛ᵒᶠ-intro; ⇛ᵒ-join; ⇛ᵒᶠ-join; ⇛ᵒ-eatˡ; ⇛ᵒᶠ-eatˡ; ⇛ᵒᶠ⇒⇛ᵒᶠᴺ)

private variable
  ł :  Level
  ι ι' :  Size
  X :  Set₀
  T :  Type
  Pᵒ Qᵒ :  Propᵒ ł
  Pᵒ˙ Qᵒ˙ :  X → Propᵒ ł
  v :  X
  red :  Redex T
  kr :  Ktxred T
  vk :  Val/Ktxred T
  e :  Expr∞ T
  eˇ :  ¿ Expr∞ T

--------------------------------------------------------------------------------
-- ᵃ⟨ ⟩ᵒ :  Semantic atomic weakest precondition

infix 3 ᵃ⟨_⟩ᵒ_

ᵃ⟨_⟩ᵒ_ :  Redex T →  (Val T → Propᵒ ł) →  Propᵒ (1ᴸ ⊔ᴸ ł)
ᵃ⟨ red ⟩ᵒ Pᵒ =  ∀ᵒ M , ⟨ M ⟩⇛ᵒ⟨ M ⟩ ⌜ (red , M) ⇒ᴿ∑ ⌝ᵒ×
                  ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴿ (red , M) ⌝ᵒ→
                    ∃ᵒ v , ⌜ e ≡ V⇒E v × eˇ ≡ ň ⌝ᵒ×  ⟨ M ⟩⇛ᵒ⟨ M' ⟩  Pᵒ v

--------------------------------------------------------------------------------
-- ⁺⟨ ⟩ᴾᵒ etc. :  Semantic partial weakest precondition

infix 3 ⁺⟨_⟩ᴾᵒ[_]_ ⟨_⟩ᴾᵒ[_]_ ⟨_⟩ᴾᵒ[<_]_

-- Wpᴾ :  ⁺⟨ ⟩ᴾᵒ[ ] with the arguments re-ordered

data  Wpᴾ (Pᵒ˙ : Val T → Propᵒ ł) (ι : Size) :  Val/Ktxred T →  Propᵒ (1ᴸ ⊔ᴸ ł)

-- ⁺⟨ ⟩ᴾᵒ[ ] :  Semantic partial weakest precondition on Val/Ktxred
-- ⟨ ⟩ᴾᵒ[ ] :  ⁺⟨ ⟩ᴾᵒ[ ] on Expr
-- ⟨ ⟩ᴾᵒ[< ] :  ⟨ ⟩ᴾᵒ[ ] under Thunk

⁺⟨_⟩ᴾᵒ[_]_ :  Val/Ktxred T →  Size →  (Val T → Propᵒ ł) →  Propᵒ (1ᴸ ⊔ᴸ ł)
⁺⟨ kr ⟩ᴾᵒ[ ι ] Pᵒ˙ =  Wpᴾ Pᵒ˙ ι kr

⟨_⟩ᴾᵒ[_]_ ⟨_⟩ᴾᵒ[<_]_ :  Expr∞ T →  Size →  (Val T → Propᵒ ł) →  Propᵒ (1ᴸ ⊔ᴸ ł)
⟨ e ⟩ᴾᵒ[ ι ] Pᵒ˙ =  ⁺⟨ val/ktxred e ⟩ᴾᵒ[ ι ] Pᵒ˙
⟨ e ⟩ᴾᵒ[< ι ] Pᵒ˙ =  Thunkᵒ (⟨ e ⟩ᴾᵒ[_] Pᵒ˙) ι

-- ⁺⟨ ⟩ᴾᵒ⊤[ ] :  Semantic partial weakest precondition on Val/Ktxred,
--               without the postcondition, used for forked threads

-- Wpᴾ⊤ :  ⁺⟨ ⟩ᴾᵒ⊤[ ] with the arguments re-ordered

data  Wpᴾ⊤ (ι : Size) :  Val/Ktxred (◸ ⊤) →  Propᵒ 1ᴸ

⁺⟨_⟩ᴾᵒ⊤[_] :  Val/Ktxred (◸ ⊤) →  Size →  Propᵒ 1ᴸ
⁺⟨ vk ⟩ᴾᵒ⊤[ ι ] =  Wpᴾ⊤ ι vk

-- ⟨ ⟩ᴾᵒ⊤[ ] :  ⁺⟨ ⟩ᴾᵒ⊤[ ] on Expr
-- ⟨ ⟩ᴾᵒ⊤[< ] :  ⟨ ⟩ᴾᵒ⊤[ ] under Thunk

⟨_⟩ᴾᵒ⊤[_] ⟨_⟩ᴾᵒ⊤[<_] :  Expr∞ (◸ ⊤) →  Size →  Propᵒ 1ᴸ
⟨ e ⟩ᴾᵒ⊤[ ι ] =  ⁺⟨ val/ktxred e ⟩ᴾᵒ⊤[ ι ]
⟨ e ⟩ᴾᵒ⊤[< ι ] =  Thunkᵒ (⟨ e ⟩ᴾᵒ⊤[_]) ι

data  Wpᴾ⊤ ι  where

  -- For a value

  ⁺⟨⟩ᴾᵒ⊤-val :  ⊨  ⁺⟨ ĩ₀ v ⟩ᴾᵒ⊤[ ι ]

  -- For a context-redex pair (c.f. ⁺⟨⟩ᴾᵒ-kr')

  ⁺⟨⟩ᴾᵒ⊤-kr' :  [⊤]ᴺᵒ -∗ᵒ' (∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                  ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                    ⟨ M ⟩⇛ᵒ'⟨ M' ⟩  ⟨ e ⟩ᴾᵒ⊤[< ι ] ∗ᵒ'
                      ¿-case (⟨_⟩ᴾᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ' [⊤]ᴺᵒ)  ⊨
                ⁺⟨ ĩ₁ kr ⟩ᴾᵒ⊤[ ι ]

-- Define Wpᴾ

data  Wpᴾ Pᵒ˙ ι  where

  -- For a value, having the postcondition under ⇛ᵒ

  ⁺⟨⟩ᴾᵒ-val :  ⇛ᵒᶠᴺ Pᵒ˙ v  ⊨  ⁺⟨ ĩ₀ v ⟩ᴾᵒ[ ι ] Pᵒ˙

  -- For a context-redex pair, stating that the reduction is not stuck
  -- and for every next state the weakest precondition coinductively holds

  -- We should use ⇛ᵒ' (the concrete version) instead of ⇛ᵒ (the abstract
  -- version) here to pass the strict positivity check

  ⁺⟨⟩ᴾᵒ-kr' :  [⊤]ᴺᵒ -∗ᵒ' (∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                 ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                   ⟨ M ⟩⇛ᵒ'⟨ M' ⟩  (⟨ e ⟩ᴾᵒ[< ι ] Pᵒ˙) ∗ᵒ'
                     ¿-case (⟨_⟩ᴾᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ' [⊤]ᴺᵒ)  ⊨
               ⁺⟨ ĩ₁ kr ⟩ᴾᵒ[ ι ] Pᵒ˙

--------------------------------------------------------------------------------
-- ⁺⟨ ⟩ᵀᵒ etc. :  Semantic total weakest precondition

infix 3 ⁺⟨_⟩ᵀᵒ[_]_ ⟨_⟩ᵀᵒ[_]_ ⟨_⟩ᵀᵒ[<_]_

-- Wpᵀ :  ⁺⟨ ⟩ᵀᵒ[ ] with the arguments re-ordered

data  Wpᵀ (Pᵒ˙ : Val T → Propᵒ ł) (ι : Size) :  Val/Ktxred T →  Propᵒ (1ᴸ ⊔ᴸ ł)

-- ⁺⟨ ⟩ᵀᵒ[ ] :  Semantic total weakest precondition on Val/Ktxred
-- ⟨ ⟩ᵀᵒ[ ] :  ⁺⟨ ⟩ᵀᵒ[ ] on Expr
-- ⟨ ⟩[< ]ᵀᵒ :  ⟨ ⟩ᵀᵒ[ ] under Thunk

⁺⟨_⟩ᵀᵒ[_]_ :  Val/Ktxred T →  Size →  (Val T → Propᵒ ł) →  Propᵒ (1ᴸ ⊔ᴸ ł)
⁺⟨ kr ⟩ᵀᵒ[ ι ] Pᵒ˙ =  Wpᵀ Pᵒ˙ ι kr

-- We use Shrunk for defining Wpᵀ, which enables induction based semantically on
-- the size rather than on the syntactic structure.

⟨_⟩ᵀᵒ[_]_ ⟨_⟩ᵀᵒ[<_]_ :  Expr∞ T →  Size →  (Val T → Propᵒ ł) →  Propᵒ (1ᴸ ⊔ᴸ ł)
⟨ e ⟩ᵀᵒ[ ι ] Pᵒ˙ =  ⁺⟨ val/ktxred e ⟩ᵀᵒ[ ι ] Pᵒ˙
⟨ e ⟩ᵀᵒ[< ι ] Pᵒ˙ =  Shrunkᵒ (⟨ e ⟩ᵀᵒ[_] Pᵒ˙) ι

-- ⁺⟨ ⟩ᵀᵒ⊤[ ] :  Semantic total total precondition on Val/Ktxred,
--               without the postcondition, used for forked threads

-- Wpᵀ⊤ :  ⁺⟨ ⟩ᵀᵒ⊤[ ] with the arguments re-ordered

data  Wpᵀ⊤ (ι : Size) :  Val/Ktxred (◸ ⊤) →  Propᵒ 1ᴸ

⁺⟨_⟩ᵀᵒ⊤[_] :  Val/Ktxred (◸ ⊤) →  Size →  Propᵒ 1ᴸ
⁺⟨ vk ⟩ᵀᵒ⊤[ ι ] =  Wpᵀ⊤ ι vk

-- ⟨ ⟩ᵀᵒ⊤[ ] :  ⁺⟨ ⟩ᵀᵒ⊤[ ] on Expr
-- ⟨ ⟩ᵀᵒ⊤[< ] :  ⟨ ⟩ᵀᵒ⊤[ ] under Shrunk

⟨_⟩ᵀᵒ⊤[_] ⟨_⟩ᵀᵒ⊤[<_] :  Expr∞ (◸ ⊤) →  Size →  Propᵒ 1ᴸ
⟨ e ⟩ᵀᵒ⊤[ ι ] =  ⁺⟨ val/ktxred e ⟩ᵀᵒ⊤[ ι ]
⟨ e ⟩ᵀᵒ⊤[< ι ] =  Shrunkᵒ (⟨ e ⟩ᵀᵒ⊤[_]) ι

data  Wpᵀ⊤ ι  where

  -- For a value

  ⁺⟨⟩ᵀᵒ⊤-val :  ⊨  ⁺⟨ ĩ₀ v ⟩ᵀᵒ⊤[ ι ]

  -- For a context-redex pair (c.f. ⁺⟨⟩ᵀᵒ-kr')

  ⁺⟨⟩ᵀᵒ⊤-kr' :  [⊤]ᴺᵒ -∗ᵒ' (∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                  ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                    ⟨ M ⟩⇛ᵒ'⟨ M' ⟩  ⟨ e ⟩ᵀᵒ⊤[< ι ] ∗ᵒ'
                      ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ' [⊤]ᴺᵒ)  ⊨
                ⁺⟨ ĩ₁ kr ⟩ᵀᵒ⊤[ ι ]

-- Define Wpᵀ

data  Wpᵀ Pᵒ˙ ι  where

  -- For a value, having the postcondition under ⇛ᵒ

  ⁺⟨⟩ᵀᵒ-val :  ⇛ᵒᶠᴺ Pᵒ˙ v  ⊨  ⁺⟨ ĩ₀ v ⟩ᵀᵒ[ ι ] Pᵒ˙

  -- For a context-redex pair, stating that the reduction is not stuck
  -- and for every next state the weakest precondition inductively holds

  ⁺⟨⟩ᵀᵒ-kr' :  [⊤]ᴺᵒ -∗ᵒ' (∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                 ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                   ⟨ M ⟩⇛ᵒ'⟨ M' ⟩  (⟨ e ⟩ᵀᵒ[< ι ] Pᵒ˙) ∗ᵒ'
                     ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ' [⊤]ᴺᵒ)  ⊨
               ⁺⟨ ĩ₁ kr ⟩ᵀᵒ[ ι ] Pᵒ˙

--------------------------------------------------------------------------------
-- Lemmas on the atomic, partial and total weakest preconditions

abstract

  -- Invert ⁺⟨⟩ᴾ/ᵀᵒ-val

  ⁺⟨⟩ᴾᵒ-val⁻¹ :  ⁺⟨ ĩ₀ v ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨  [⊤]ᴺᵒ -∗ᵒ (⇛ᵒᶠ Pᵒ˙ v ∗ᵒ [⊤]ᴺᵒ)
  ⁺⟨⟩ᴾᵒ-val⁻¹ (⁺⟨⟩ᴾᵒ-val ⇛Pv) =  ⇛Pv

  ⁺⟨⟩ᵀᵒ-val⁻¹ :  ⁺⟨ ĩ₀ v ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨  [⊤]ᴺᵒ -∗ᵒ (⇛ᵒᶠ Pᵒ˙ v ∗ᵒ [⊤]ᴺᵒ)
  ⁺⟨⟩ᵀᵒ-val⁻¹ (⁺⟨⟩ᵀᵒ-val ⇛Pv) =  ⇛Pv

  -- Modified ⁺⟨⟩ᴾ/ᵀᵒ-kr'

  ⁺⟨⟩ᴾᵒ-kr :  [⊤]ᴺᵒ -∗ᵒ (∀ᵒ M , ⟨ M ⟩⇛ᵒ⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                  ⟨ M ⟩⇛ᵒ⟨ M' ⟩  (⟨ e ⟩ᴾᵒ[< ι ] Pᵒ˙) ∗ᵒ
                    ¿-case (⟨_⟩ᴾᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ [⊤]ᴺᵒ)  ⊨
              ⁺⟨ ĩ₁ kr ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᴾᵒ-kr big =  ⁺⟨⟩ᴾᵒ-kr' $ big ▷ -∗ᵒ-monoʳ (λ big M → big M ▷ (⇛ᵒ-mono
    λ (krM⇒ , big) → krM⇒ , λ e eˇ M' eeˇM'⇐krM → big e eˇ M' eeˇM'⇐krM ▷
    ⇛ᵒ-mono (∗ᵒ-monoʳ ∗ᵒ⇒∗ᵒ' › ∗ᵒ⇒∗ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷ -∗ᵒ⇒-∗ᵒ'

  ⁺⟨⟩ᵀᵒ-kr :  [⊤]ᴺᵒ -∗ᵒ (∀ᵒ M , ⟨ M ⟩⇛ᵒ⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                  ⟨ M ⟩⇛ᵒ⟨ M' ⟩  (⟨ e ⟩ᵀᵒ[< ι ] Pᵒ˙) ∗ᵒ
                    ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ [⊤]ᴺᵒ)  ⊨
              ⁺⟨ ĩ₁ kr ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᵀᵒ-kr big =  ⁺⟨⟩ᵀᵒ-kr' $ big ▷ -∗ᵒ-monoʳ (λ big M → big M ▷ (⇛ᵒ-mono
    λ (krM⇒ , big) → krM⇒ , λ e eˇ M' eeˇM'⇐krM → big e eˇ M' eeˇM'⇐krM ▷
    ⇛ᵒ-mono (∗ᵒ-monoʳ ∗ᵒ⇒∗ᵒ' › ∗ᵒ⇒∗ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷ -∗ᵒ⇒-∗ᵒ'

  -- Invert ⁺⟨⟩ᴾ/ᵀᵒ-kr

  ⁺⟨⟩ᴾᵒ-kr⁻¹ :  ⁺⟨ ĩ₁ kr ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨
                [⊤]ᴺᵒ -∗ᵒ (∀ᵒ M , ⟨ M ⟩⇛ᵒ⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                  ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                    ⟨ M ⟩⇛ᵒ⟨ M' ⟩  (⟨ e ⟩ᴾᵒ[< ι ] Pᵒ˙) ∗ᵒ
                      ¿-case (⟨_⟩ᴾᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ [⊤]ᴺᵒ)
  ⁺⟨⟩ᴾᵒ-kr⁻¹ (⁺⟨⟩ᴾᵒ-kr' big) =  big ▷ -∗ᵒ'⇒-∗ᵒ {Qᵒ = ∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ _} ▷
    -∗ᵒ-monoʳ λ big M → big M ▷ ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ ,
    λ e eˇ M' eeˇM'⇐krM → big e eˇ M' eeˇM'⇐krM ▷ ⇛ᵒ'⇒⇛ᵒ ▷
    ⇛ᵒ-mono (∗ᵒ'⇒∗ᵒ › ∗ᵒ-monoʳ ∗ᵒ'⇒∗ᵒ)

  ⁺⟨⟩ᵀᵒ-kr⁻¹ :  ⁺⟨ ĩ₁ kr ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨
                [⊤]ᴺᵒ -∗ᵒ (∀ᵒ M , ⟨ M ⟩⇛ᵒ⟨ M ⟩ ⌜ (kr , M) ⇒ᴷᴿ∑ ⌝ᵒ×
                  ∀ᵒ e , ∀ᵒ eˇ , ∀ᵒ M' , ⌜ (e , eˇ , M') ⇐ᴷᴿ (kr , M) ⌝ᵒ→
                    ⟨ M ⟩⇛ᵒ⟨ M' ⟩  (⟨ e ⟩ᵀᵒ[< ι ] Pᵒ˙) ∗ᵒ
                      ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ ∗ᵒ [⊤]ᴺᵒ)
  ⁺⟨⟩ᵀᵒ-kr⁻¹ (⁺⟨⟩ᵀᵒ-kr' big) =  big ▷ -∗ᵒ'⇒-∗ᵒ {Qᵒ = ∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ _} ▷
    -∗ᵒ-monoʳ λ big M → big M ▷ ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ ,
    λ e eˇ M' eeˇM'⇐krM → big e eˇ M' eeˇM'⇐krM ▷ ⇛ᵒ'⇒⇛ᵒ ▷
    ⇛ᵒ-mono (∗ᵒ'⇒∗ᵒ › ∗ᵒ-monoʳ ∗ᵒ'⇒∗ᵒ)

  -- Conversion between ⁺⟨⟩ᴾ/ᵀᵒ⊤ and ⁺⟨⟩ᴾ/ᵀᵒ λ _ → ⊤ᵒ₀

  ⁺⟨⟩ᴾᵒ⊤⇒⁺⟨⟩ᴾᵒ :  ⁺⟨ vk ⟩ᴾᵒ⊤[ ι ]  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] λ _ → ⊤ᵒ₀
  ⁺⟨⟩ᴾᵒ⊤⇒⁺⟨⟩ᴾᵒ ⁺⟨⟩ᴾᵒ⊤-val =  ⁺⟨⟩ᴾᵒ-val $ -∗ᵒ-intro' ◎-Mono λ _ →
    ?∗ᵒ-intro _ › ⇛ᵒᶠ-intro
  ⁺⟨⟩ᴾᵒ⊤⇒⁺⟨⟩ᴾᵒ (⁺⟨⟩ᴾᵒ⊤-kr' big) =  ⁺⟨⟩ᴾᵒ-kr $ big ▷
    -∗ᵒ'⇒-∗ᵒ {Qᵒ = ∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ _} ▷ -∗ᵒ-monoʳ λ big M → big M ▷
    ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐krM →
    big _ _ _ eeˇM'⇐krM ▷ ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono (∗ᵒ'⇒∗ᵒ ›
    ∗ᵒ-mono (λ big → λ{ .! → ⁺⟨⟩ᴾᵒ⊤⇒⁺⟨⟩ᴾᵒ (big .!) }) ∗ᵒ'⇒∗ᵒ)

  ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ :  ⁺⟨ vk ⟩ᵀᵒ⊤[ ι ]  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] λ _ → ⊤ᵒ₀
  ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ ⁺⟨⟩ᵀᵒ⊤-val =  ⁺⟨⟩ᵀᵒ-val $ -∗ᵒ-intro' ◎-Mono λ _ →
    ?∗ᵒ-intro _ › ⇛ᵒᶠ-intro
  ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ (⁺⟨⟩ᵀᵒ⊤-kr' big) =  ⁺⟨⟩ᵀᵒ-kr $ big ▷
    -∗ᵒ'⇒-∗ᵒ {Qᵒ = ∀ᵒ M , ⟨ M ⟩⇛ᵒ'⟨ M ⟩ _} ▷ -∗ᵒ-monoʳ λ big M → big M ▷
    ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐krM →
    big _ _ _ eeˇM'⇐krM ▷ ⇛ᵒ'⇒⇛ᵒ ▷ ⇛ᵒ-mono (∗ᵒ'⇒∗ᵒ ›
    ∗ᵒ-mono (λ{ (§ big) → § ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ big }) ∗ᵒ'⇒∗ᵒ)

  ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤ :  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᴾᵒ⊤[ ι ]
  ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤ {vk = ĩ₀ _} _ =  ⁺⟨⟩ᴾᵒ⊤-val
  ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤ {vk = ĩ₁ _} ⟨kr⟩P =  ⁺⟨⟩ᴾᵒ⊤-kr' $ ⁺⟨⟩ᴾᵒ-kr⁻¹ ⟨kr⟩P ▷ -∗ᵒ-monoʳ
    (λ big M → big M ▷ ⇛ᵒ-mono (λ (krM⇒ , big) → krM⇒ , λ e eˇ M' eeˇM'⇐krM →
    big e eˇ M' eeˇM'⇐krM ▷ ⇛ᵒ-mono (∗ᵒ-mono {Qᵒ = ⟨ _ ⟩ᴾᵒ⊤[< _ ]} (λ big →
    λ{ .! {ι'} → ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤ (big .! {ι'}) }) ∗ᵒ⇒∗ᵒ' › ∗ᵒ⇒∗ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷
    ⇛ᵒ⇒⇛ᵒ') ▷ -∗ᵒ⇒-∗ᵒ'

  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᵀᵒ⊤ :  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᵀᵒ⊤[ ι ]
  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᵀᵒ⊤ {vk = ĩ₀ _} _ =  ⁺⟨⟩ᵀᵒ⊤-val
  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᵀᵒ⊤ {vk = ĩ₁ _} {ι} ⟨kr⟩P =  ⁺⟨⟩ᵀᵒ⊤-kr' $ ⁺⟨⟩ᵀᵒ-kr⁻¹ ⟨kr⟩P ▷
    -∗ᵒ-monoʳ (λ big M → big M ▷ ⇛ᵒ-mono (λ (krM⇒ , big) → krM⇒ ,
    λ e eˇ M' eeˇM'⇐krM → big e eˇ M' eeˇM'⇐krM ▷ ⇛ᵒ-mono
    (∗ᵒ-mono (λ{ (§_ big) → §_ {ι = ι} $ ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᵀᵒ⊤ big }) ∗ᵒ⇒∗ᵒ' › ∗ᵒ⇒∗ᵒ') ▷
    ⇛ᵒ⇒⇛ᵒ') ▷ ⇛ᵒ⇒⇛ᵒ') ▷ -∗ᵒ⇒-∗ᵒ'

  -- Monoᵒ for ᵃ⟨⟩ᵒ, ⁺⟨⟩ᴾ/ᵀᵒ and ⁺⟨⟩ᴾ/ᵀᵒ⊤

  ᵃ⟨⟩ᵒ-Mono :  Monoᵒ $ ᵃ⟨ red ⟩ᵒ Pᵒ˙
  ᵃ⟨⟩ᵒ-Mono a⊑b ⟨red⟩P M =  ⟨red⟩P M ▷ ⇛ᵒ-Mono a⊑b

  ⁺⟨⟩ᴾᵒ-Mono :  Monoᵒ $ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᴾᵒ-Mono {vk = ĩ₀ _} a⊑b =  ⁺⟨⟩ᴾᵒ-val⁻¹ › -∗ᵒ-Mono a⊑b › ⁺⟨⟩ᴾᵒ-val
  ⁺⟨⟩ᴾᵒ-Mono {vk = ĩ₁ _} a⊑b =  ⁺⟨⟩ᴾᵒ-kr⁻¹ › -∗ᵒ-Mono a⊑b › ⁺⟨⟩ᴾᵒ-kr

  ⁺⟨⟩ᵀᵒ-Mono :  Monoᵒ $ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᵀᵒ-Mono {vk = ĩ₀ _} a⊑b =  ⁺⟨⟩ᵀᵒ-val⁻¹ › -∗ᵒ-Mono a⊑b › ⁺⟨⟩ᵀᵒ-val
  ⁺⟨⟩ᵀᵒ-Mono {vk = ĩ₁ _} a⊑b =  ⁺⟨⟩ᵀᵒ-kr⁻¹ › -∗ᵒ-Mono a⊑b › ⁺⟨⟩ᵀᵒ-kr

  ⁺⟨⟩ᴾᵒ⊤-Mono :  Monoᵒ ⁺⟨ vk ⟩ᴾᵒ⊤[ ι ]
  ⁺⟨⟩ᴾᵒ⊤-Mono a⊑b =  ⁺⟨⟩ᴾᵒ⊤⇒⁺⟨⟩ᴾᵒ › ⁺⟨⟩ᴾᵒ-Mono a⊑b › ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤

  ⁺⟨⟩ᵀᵒ⊤-Mono :  Monoᵒ ⁺⟨ vk ⟩ᵀᵒ⊤[ ι ]
  ⁺⟨⟩ᵀᵒ⊤-Mono a⊑b =  ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ › ⁺⟨⟩ᵀᵒ-Mono a⊑b › ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᵀᵒ⊤

  -- Monotonicity of ᵃ⟨⟩ᵒ and ⁺⟨⟩ᴾ/ᵀᵒ

  ᵃ⟨⟩ᵒ-mono✓ :  (∀ v → Pᵒ˙ v ⊨✓ Qᵒ˙ v) →  ᵃ⟨ red ⟩ᵒ Pᵒ˙ ⊨ ᵃ⟨ red ⟩ᵒ Qᵒ˙
  ᵃ⟨⟩ᵒ-mono✓ Pv⊨✓Qv big M =  big M ▷ ⇛ᵒ-mono λ (redM⇒ , big) → redM⇒ ,
    λ _ _ _ eeˇM'⇐krM → big _ _ _ eeˇM'⇐krM ▷ λ (-, ≡vň , big) → -, ≡vň ,
    big ▷ ⇛ᵒ-mono✓ (Pv⊨✓Qv _)

  ᵃ⟨⟩ᵒ-mono :  (∀ v → Pᵒ˙ v ⊨ Qᵒ˙ v) →  ᵃ⟨ red ⟩ᵒ Pᵒ˙ ⊨ ᵃ⟨ red ⟩ᵒ Qᵒ˙
  ᵃ⟨⟩ᵒ-mono =  (⊨⇒⊨✓ ∘_) › ᵃ⟨⟩ᵒ-mono✓

  ⁺⟨⟩ᴾᵒ-mono✓ :  (∀ v → Pᵒ˙ v ⊨✓ Qᵒ˙ v) →
                 ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙ ⊨ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Qᵒ˙
  ⁺⟨⟩ᴾᵒ-mono✓ {vk = ĩ₀ _} Pv⊨✓Qv =  ⁺⟨⟩ᴾᵒ-val⁻¹ › -∗ᵒ-monoʳ
    (λ big M → big M ▷ ⇛ᵒ-mono✓ (∗ᵒ-mono✓ˡ $ Pv⊨✓Qv _)) › ⁺⟨⟩ᴾᵒ-val
  ⁺⟨⟩ᴾᵒ-mono✓ {vk = ĩ₁ _} Pv⊨✓Qv =  ⁺⟨⟩ᴾᵒ-kr⁻¹ › -∗ᵒ-monoʳ (λ big M → big M ▷
    ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐krM → big _ _ _ eeˇM'⇐krM ▷
    ⇛ᵒ-mono (∗ᵒ-monoˡ λ big → λ{ .! → ⁺⟨⟩ᴾᵒ-mono✓ Pv⊨✓Qv $ big .! })) › ⁺⟨⟩ᴾᵒ-kr

  ⁺⟨⟩ᴾᵒ-mono :  (∀ v → Pᵒ˙ v ⊨ Qᵒ˙ v) →  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙ ⊨ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Qᵒ˙
  ⁺⟨⟩ᴾᵒ-mono =  (⊨⇒⊨✓ ∘_) › ⁺⟨⟩ᴾᵒ-mono✓

  ⁺⟨⟩ᵀᵒ-mono✓ :  (∀ v → Pᵒ˙ v ⊨✓ Qᵒ˙ v) →
                 ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙ ⊨ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Qᵒ˙
  ⁺⟨⟩ᵀᵒ-mono✓ {vk = ĩ₀ _} Pv⊨✓Qv =  ⁺⟨⟩ᵀᵒ-val⁻¹ › -∗ᵒ-monoʳ
    (λ big M → big M ▷ ⇛ᵒ-mono✓ (∗ᵒ-mono✓ˡ $ Pv⊨✓Qv _)) › ⁺⟨⟩ᵀᵒ-val
  ⁺⟨⟩ᵀᵒ-mono✓ {vk = ĩ₁ _} Pv⊨✓Qv =  ⁺⟨⟩ᵀᵒ-kr⁻¹ › -∗ᵒ-monoʳ (λ big M → big M ▷
    ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐krM → big _ _ _ eeˇM'⇐krM ▷
    ⇛ᵒ-mono (∗ᵒ-monoˡ λ{ (§ big) → § ⁺⟨⟩ᵀᵒ-mono✓ Pv⊨✓Qv big })) › ⁺⟨⟩ᵀᵒ-kr

  ⁺⟨⟩ᵀᵒ-mono :  (∀ v → Pᵒ˙ v ⊨ Qᵒ˙ v) →  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙ ⊨ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Qᵒ˙
  ⁺⟨⟩ᵀᵒ-mono =  (⊨⇒⊨✓ ∘_) › ⁺⟨⟩ᵀᵒ-mono✓

  -- ⊨✓ into ⊨ when the right-hand side is ᵃ⟨⟩ᵒ or ⁺⟨⟩ᴾ/ᵀᵒ

  ⊨✓⇒⊨-ᵃ⟨⟩ᵒ :  Pᵒ ⊨✓ ᵃ⟨ red ⟩ᵒ Qᵒ˙ →  Pᵒ ⊨ ᵃ⟨ red ⟩ᵒ Qᵒ˙
  ⊨✓⇒⊨-ᵃ⟨⟩ᵒ P⊨✓⟨red⟩Q Pa M =  Pa ▷ ⊨✓⇒⊨-⇛ᵒ (λ ✓∙ Pb → P⊨✓⟨red⟩Q ✓∙ Pb M)

  ⊨✓⇒⊨-⁺⟨⟩ᴾᵒ :  Pᵒ ⊨✓ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Qᵒ˙ →  Pᵒ ⊨ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Qᵒ˙
  ⊨✓⇒⊨-⁺⟨⟩ᴾᵒ {vk = ĩ₀ _} P⊨✓⟨v⟩Q Pa =  Pa ▷
    ⊨✓⇒⊨--∗ᵒ (λ ✓∙ Pb → P⊨✓⟨v⟩Q ✓∙ Pb ▷ ⁺⟨⟩ᴾᵒ-val⁻¹) ▷ ⁺⟨⟩ᴾᵒ-val
  ⊨✓⇒⊨-⁺⟨⟩ᴾᵒ {vk = ĩ₁ _} P⊨✓⟨kr⟩Q Pa =  Pa ▷
    ⊨✓⇒⊨--∗ᵒ (λ ✓∙ Pb → P⊨✓⟨kr⟩Q ✓∙ Pb ▷ ⁺⟨⟩ᴾᵒ-kr⁻¹) ▷ ⁺⟨⟩ᴾᵒ-kr

  ⊨✓⇒⊨-⁺⟨⟩ᵀᵒ :  Pᵒ ⊨✓ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Qᵒ˙ →  Pᵒ ⊨ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Qᵒ˙
  ⊨✓⇒⊨-⁺⟨⟩ᵀᵒ {vk = ĩ₀ _} P⊨✓⟨v⟩Q Pa =  Pa ▷
    ⊨✓⇒⊨--∗ᵒ (λ ✓∙ Pb → P⊨✓⟨v⟩Q ✓∙ Pb ▷ ⁺⟨⟩ᵀᵒ-val⁻¹) ▷ ⁺⟨⟩ᵀᵒ-val
  ⊨✓⇒⊨-⁺⟨⟩ᵀᵒ {vk = ĩ₁ _} P⊨✓⟨kr⟩Q Pa =  Pa ▷
    ⊨✓⇒⊨--∗ᵒ (λ ✓∙ Pb → P⊨✓⟨kr⟩Q ✓∙ Pb ▷ ⁺⟨⟩ᵀᵒ-kr⁻¹) ▷ ⁺⟨⟩ᵀᵒ-kr

  -- Modify the size of ⁺⟨⟩ᴾ/ᵀᵒ / ¿-case (⟨ ⟩ᵀᵒ⊤[< ]) ⊤ᵒ

  ⁺⟨⟩ᴾᵒ-size :  ∀{ι' : Size< ι} →  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι' ] Pᵒ˙
  ⁺⟨⟩ᴾᵒ-size ⟨vk⟩P =  ⟨vk⟩P

  ⁺⟨⟩ᵀᵒ-size :  ∀{ι' : Size< ι} →  ⁺⟨ vk ⟩ᵀᵒ[ ι' ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᵀᵒ-size ⟨vk⟩P =  ⟨vk⟩P

  ¿⁺⟨⟩ᵀᵒ⊤<-size :  ∀{ι' : Size< ι} →
    ¿-case (⟨_⟩ᵀᵒ⊤[< ι' ]) ⊤ᵒ eˇ  ⊨  ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ
  ¿⁺⟨⟩ᵀᵒ⊤<-size ⟨vk⟩P =  ⟨vk⟩P

  -- Convert ⁺⟨⟩ᵀᵒ into ⁺⟨⟩ᴾᵒ

  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᴾᵒ :  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι' ] Pᵒ˙
  ¿⁺⟨⟩ᵀᵒ⊤<⇒¿⁺⟨⟩ᴾᵒ⊤< :
    ¿-case (⟨_⟩ᵀᵒ⊤[< ι ]) ⊤ᵒ eˇ  ⊨  ¿-case (⟨_⟩ᴾᵒ⊤[< ι' ]) ⊤ᵒ eˇ

  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᴾᵒ {vk = ĩ₀ _} ⟨v⟩P =  ⁺⟨⟩ᴾᵒ-val $ ⁺⟨⟩ᵀᵒ-val⁻¹ ⟨v⟩P
  ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᴾᵒ {vk = ĩ₁ _} ⟨kr⟩P =  ⁺⟨⟩ᴾᵒ-kr $ ⁺⟨⟩ᵀᵒ-kr⁻¹ ⟨kr⟩P ▷ -∗ᵒ-monoʳ
    λ big M → big M ▷ ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ eˇ _ eeˇM'⇐krM →
    big _ _ _ eeˇM'⇐krM ▷ ⇛ᵒ-mono (∗ᵒ-mono
    (λ{ (§ big) → λ{ .! → ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᴾᵒ big }}) $
    ∗ᵒ-monoˡ $ ¿⁺⟨⟩ᵀᵒ⊤<⇒¿⁺⟨⟩ᴾᵒ⊤< {eˇ = eˇ})

  ¿⁺⟨⟩ᵀᵒ⊤<⇒¿⁺⟨⟩ᴾᵒ⊤< {eˇ = ň} _ =  _
  ¿⁺⟨⟩ᵀᵒ⊤<⇒¿⁺⟨⟩ᴾᵒ⊤< {eˇ = š _} (§ big) .! =
    big ▷ ⁺⟨⟩ᵀᵒ⊤⇒⁺⟨⟩ᵀᵒ ▷ ⁺⟨⟩ᵀᵒ⇒⁺⟨⟩ᴾᵒ ▷ ⁺⟨⟩ᴾᵒ⇒⁺⟨⟩ᴾᵒ⊤

  -- ᵃ⟨⟩ᵒ absorbs ⇛ᵒᶠ outside

  ⇛ᵒᶠ-ᵃ⟨⟩ᵒ :  ⇛ᵒᶠ ᵃ⟨ red ⟩ᵒ Pᵒ˙  ⊨  ᵃ⟨ red ⟩ᵒ Pᵒ˙
  ⇛ᵒᶠ-ᵃ⟨⟩ᵒ big M =  big M ▷ ⇛ᵒ-mono (_$ _) ▷ ⇛ᵒ-join

  -- ⁺⟨⟩ᴾ/ᵀᵒ absorbs ⇛ᵒᶠᴺ/⇛ᵒᶠ outside

  ⇛ᵒᶠᴺ-⁺⟨⟩ᴾᵒ :  ⇛ᵒᶠᴺ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⇛ᵒᶠᴺ-⁺⟨⟩ᴾᵒ {vk = ĩ₀ _} =  (-∗ᵒ-monoʳ $ ⇛ᵒᶠ-mono✓ (λ ✓∙ → ∗ᵒ-monoˡ ⁺⟨⟩ᴾᵒ-val⁻¹ ›
    -∗ᵒ-applyʳ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ✓∙) › ⇛ᵒᶠ-join) › ⁺⟨⟩ᴾᵒ-val
  ⇛ᵒᶠᴺ-⁺⟨⟩ᴾᵒ {vk = ĩ₁ _} =  (-∗ᵒ-monoʳ λ big M → big M ▷ ⇛ᵒ-mono✓ (λ ✓∙ →
    ∗ᵒ-monoˡ ⁺⟨⟩ᴾᵒ-kr⁻¹ › -∗ᵒ-applyʳ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ✓∙ › _$ _) ▷
    ⇛ᵒ-join) › ⁺⟨⟩ᴾᵒ-kr

  ⇛ᵒᶠ-⁺⟨⟩ᴾᵒ :  ⇛ᵒᶠ ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⇛ᵒᶠ-⁺⟨⟩ᴾᵒ =  ⇛ᵒᶠ⇒⇛ᵒᶠᴺ › ⇛ᵒᶠᴺ-⁺⟨⟩ᴾᵒ

  ⇛ᵒᶠᴺ-⁺⟨⟩ᵀᵒ :  ⇛ᵒᶠᴺ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⇛ᵒᶠᴺ-⁺⟨⟩ᵀᵒ {vk = ĩ₀ _} =  (-∗ᵒ-monoʳ $ ⇛ᵒᶠ-mono✓ (λ ✓∙ → ∗ᵒ-monoˡ ⁺⟨⟩ᵀᵒ-val⁻¹ ›
    -∗ᵒ-applyʳ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ✓∙) › ⇛ᵒᶠ-join) › ⁺⟨⟩ᵀᵒ-val
  ⇛ᵒᶠᴺ-⁺⟨⟩ᵀᵒ {vk = ĩ₁ _} =  (-∗ᵒ-monoʳ λ big M → big M ▷ ⇛ᵒ-mono✓ (λ ✓∙ →
    ∗ᵒ-monoˡ ⁺⟨⟩ᵀᵒ-kr⁻¹ › -∗ᵒ-applyʳ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ✓∙ › _$ _) ▷
    ⇛ᵒ-join) › ⁺⟨⟩ᵀᵒ-kr

  ⇛ᵒᶠ-⁺⟨⟩ᵀᵒ :  ⇛ᵒᶠ ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⇛ᵒᶠ-⁺⟨⟩ᵀᵒ =  ⇛ᵒᶠ⇒⇛ᵒᶠᴺ › ⇛ᵒᶠᴺ-⁺⟨⟩ᵀᵒ

  -- ᵃ⟨⟩ᵒ absorbs ⇛ᵒᶠ inside

  ᵃ⟨⟩ᵒ-⇛ᵒᶠ :  ᵃ⟨ red ⟩ᵒ (λ v → ⇛ᵒᶠ Pᵒ˙ v)  ⊨  ᵃ⟨ red ⟩ᵒ Pᵒ˙
  ᵃ⟨⟩ᵒ-⇛ᵒᶠ big M =  big M ▷ ⇛ᵒ-mono λ (redM⇒ , big) → redM⇒ , λ _ _ _ veˇM'⇐ →
    big _ _ _ veˇM'⇐ ▷ λ (-, ≡vň , big) → -, ≡vň ,
    big ▷ ⇛ᵒ-mono (_$ _) ▷ ⇛ᵒ-join

  -- ⁺⟨⟩ᴾ/ᵀᵒ absorbs ⇛ᵒᶠᴺ/⇛ᵒᶠ inside

  ⁺⟨⟩ᴾᵒ-⇛ᵒᶠᴺ :  ⁺⟨ vk ⟩ᴾᵒ[ ι ] (λ v → ⇛ᵒᶠᴺ Pᵒ˙ v)  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᴾᵒ-⇛ᵒᶠᴺ {vk = ĩ₀ _} =  ⁺⟨⟩ᴾᵒ-val⁻¹ › (-∗ᵒ-monoʳ $
    ⇛ᵒᶠ-mono✓ (λ ✓∙ → -∗ᵒ-applyʳ ⇛ᵒᶠ-Mono ✓∙) › ⇛ᵒᶠ-join) › ⁺⟨⟩ᴾᵒ-val
  ⁺⟨⟩ᴾᵒ-⇛ᵒᶠᴺ {vk = ĩ₁ _} =  ⁺⟨⟩ᴾᵒ-kr⁻¹ › (-∗ᵒ-monoʳ λ big M → big M ▷
    ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐ → big _ _ _ eeˇM'⇐ ▷
    ⇛ᵒ-mono (∗ᵒ-monoˡ λ big → λ{ .! → ⁺⟨⟩ᴾᵒ-⇛ᵒᶠᴺ $ big .! })) › ⁺⟨⟩ᴾᵒ-kr

  ⁺⟨⟩ᴾᵒ-⇛ᵒᶠ :  ⁺⟨ vk ⟩ᴾᵒ[ ι ] (λ v → ⇛ᵒᶠ Pᵒ˙ v)  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᴾᵒ-⇛ᵒᶠ =  ⁺⟨⟩ᴾᵒ-mono (λ _ → ⇛ᵒᶠ⇒⇛ᵒᶠᴺ) › ⁺⟨⟩ᴾᵒ-⇛ᵒᶠᴺ

  ⁺⟨⟩ᵀᵒ-⇛ᵒᶠᴺ :  ⁺⟨ vk ⟩ᵀᵒ[ ι ] (λ v → ⇛ᵒᶠᴺ Pᵒ˙ v)  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᵀᵒ-⇛ᵒᶠᴺ {vk = ĩ₀ _} =  ⁺⟨⟩ᵀᵒ-val⁻¹ › (-∗ᵒ-monoʳ $
    ⇛ᵒᶠ-mono✓ (λ ✓∙ → -∗ᵒ-applyʳ ⇛ᵒᶠ-Mono ✓∙) › ⇛ᵒᶠ-join) › ⁺⟨⟩ᵀᵒ-val
  ⁺⟨⟩ᵀᵒ-⇛ᵒᶠᴺ {vk = ĩ₁ _} =  ⁺⟨⟩ᵀᵒ-kr⁻¹ › (-∗ᵒ-monoʳ λ big M → big M ▷
    ⇛ᵒ-mono λ (krM⇒ , big) → krM⇒ , λ _ _ _ eeˇM'⇐ → big _ _ _ eeˇM'⇐ ▷
    ⇛ᵒ-mono (∗ᵒ-monoˡ λ{ (§ big) → § ⁺⟨⟩ᵀᵒ-⇛ᵒᶠᴺ big })) › ⁺⟨⟩ᵀᵒ-kr

  ⁺⟨⟩ᵀᵒ-⇛ᵒᶠ :  ⁺⟨ vk ⟩ᵀᵒ[ ι ] (λ v → ⇛ᵒᶠ Pᵒ˙ v)  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙
  ⁺⟨⟩ᵀᵒ-⇛ᵒᶠ =  ⁺⟨⟩ᵀᵒ-mono (λ _ → ⇛ᵒᶠ⇒⇛ᵒᶠᴺ) › ⁺⟨⟩ᵀᵒ-⇛ᵒᶠᴺ

  -- Let ᵃ⟨⟩ᵒ and ⁺⟨⟩ᴾ/ᵀᵒ eat a proposition

  ᵃ⟨⟩ᵒ-eatˡ :  Qᵒ ∗ᵒ (ᵃ⟨ red ⟩ᵒ Pᵒ˙)  ⊨  ᵃ⟨ red ⟩ᵒ λ v → Qᵒ ∗ᵒ Pᵒ˙ v
  ᵃ⟨⟩ᵒ-eatˡ big M =  big ▷ ∗ᵒ-monoʳ (_$ M) ▷ ⇛ᵒ-eatˡ ▷ ⇛ᵒ-mono (∗ᵒ∃ᵒ-out ›
    λ (redM⇒ , big) → redM⇒ , λ _ _ _ veˇM'⇐ → big ▷
    ∗ᵒ-monoʳ (λ big → big _ _ _ veˇM'⇐) ▷ ∗ᵒ∃ᵒ-out ▷ λ (-, big) → -,
    big ▷ ∗ᵒ∃ᵒ-out ▷ λ (≡vň , big) → ≡vň , big ▷ ⇛ᵒ-eatˡ)

  ⁺⟨⟩ᴾᵒ-eatˡ :  Qᵒ ∗ᵒ (⁺⟨ vk ⟩ᴾᵒ[ ι ] Pᵒ˙)  ⊨  ⁺⟨ vk ⟩ᴾᵒ[ ι ] λ v → Qᵒ ∗ᵒ Pᵒ˙ v
  ⁺⟨⟩ᴾᵒ-eatˡ {vk = ĩ₀ _} =  ∗ᵒ-monoʳ ⁺⟨⟩ᴾᵒ-val⁻¹ ›
    -∗ᵒ-eatˡ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ›
    -∗ᵒ-monoʳ (⇛ᵒᶠ-eatˡ › ⇛ᵒᶠ-mono ∗ᵒ-assocʳ) › ⁺⟨⟩ᴾᵒ-val
  ⁺⟨⟩ᴾᵒ-eatˡ {vk = ĩ₁ _} =  ∗ᵒ-monoʳ ⁺⟨⟩ᴾᵒ-kr⁻¹ ›
    -∗ᵒ-eatˡ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) › -∗ᵒ-monoʳ (λ big M → big ▷
    ∗ᵒ-monoʳ (_$ M) ▷ ⇛ᵒ-eatˡ ▷ ⇛ᵒ-mono (∗ᵒ∃ᵒ-out › λ (krM⇒ , big) → krM⇒ ,
    λ _ _ _ eeˇM'⇐krM → big ▷ ∗ᵒ-monoʳ (λ big → big _ _ _ eeˇM'⇐krM) ▷ ⇛ᵒ-eatˡ ▷
    ⇛ᵒ-mono (∗ᵒ-assocʳ › ∗ᵒ-monoˡ $ ∗ᵒThunkᵒ-out ›
    λ big → λ{ .! → ⁺⟨⟩ᴾᵒ-eatˡ $ big .! }))) › ⁺⟨⟩ᴾᵒ-kr

  ⁺⟨⟩ᵀᵒ-eatˡ :  Qᵒ ∗ᵒ (⁺⟨ vk ⟩ᵀᵒ[ ι ] Pᵒ˙)  ⊨  ⁺⟨ vk ⟩ᵀᵒ[ ι ] λ v → Qᵒ ∗ᵒ Pᵒ˙ v
  ⁺⟨⟩ᵀᵒ-eatˡ {vk = ĩ₀ _} =  ∗ᵒ-monoʳ ⁺⟨⟩ᵀᵒ-val⁻¹ ›
    -∗ᵒ-eatˡ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) ›
    -∗ᵒ-monoʳ (⇛ᵒᶠ-eatˡ › ⇛ᵒᶠ-mono ∗ᵒ-assocʳ) › ⁺⟨⟩ᵀᵒ-val
  ⁺⟨⟩ᵀᵒ-eatˡ {vk = ĩ₁ _} =  ∗ᵒ-monoʳ ⁺⟨⟩ᵀᵒ-kr⁻¹ ›
    -∗ᵒ-eatˡ (∀ᵒ-Mono λ _ → ⇛ᵒ-Mono) › -∗ᵒ-monoʳ (λ big M → big ▷
    ∗ᵒ-monoʳ (_$ M) ▷ ⇛ᵒ-eatˡ ▷ ⇛ᵒ-mono (∗ᵒ∃ᵒ-out › λ (krM⇒ , big) → krM⇒ ,
    λ _ _ _ eeˇM'⇐krM → big ▷ ∗ᵒ-monoʳ (λ big → big _ _ _ eeˇM'⇐krM) ▷ ⇛ᵒ-eatˡ ▷
    ⇛ᵒ-mono (∗ᵒ-assocʳ › ∗ᵒ-monoˡ $ ∗ᵒShrunkᵒ-out ›
    λ{ (§ big) → § ⁺⟨⟩ᵀᵒ-eatˡ big }))) › ⁺⟨⟩ᵀᵒ-kr
