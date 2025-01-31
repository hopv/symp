--------------------------------------------------------------------------------
-- Fancy update on the propositional invariant
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Syng.Model.Fupd.Inv where

open import Base.Level using (Level; _⊔ᴸ_; 1ᴸ)
open import Base.Func using (_$_; _▷_; _∘_; _›_)
open import Base.Prod using (_,_; -,_; -ᴵ,_; uncurry)
open import Base.Sum using (ĩ₀_; ĩ₁_)
open import Base.Nat using (ℕ)
open import Syng.Logic.Prop using (Name; SProp∞)
open import Syng.Model.ERA.Inv using (Envᴵⁿᵛ)
open import Syng.Model.ERA.Glob using (jᴵⁿᵛ; ∅ᴵⁿᴳ)
open import Syng.Model.Prop.Base using (SPropᵒ; _⊨✓_; _⊨_; ⊨_; _⨿ᵒ_; _∗ᵒ_;
  _-∗ᵒ_; ∗ᵒ⇒∗ᵒ'; ∗ᵒ'⇒∗ᵒ; ∗ᵒ-Mono; ∗ᵒ-mono; ∗ᵒ-mono✓ˡ; ∗ᵒ-monoˡ; ∗ᵒ-mono✓ʳ;
  ∗ᵒ-monoʳ; ∗ᵒ-comm; ∗ᵒ-assocˡ; ∗ᵒ-assocʳ; ?∗ᵒ-comm; ∗ᵒ?-comm; ?∗ᵒ-intro;
  ∗ᵒ-elimʳ; ∗ᵒ⨿ᵒ-out; -∗ᵒ-applyˡ; ⤇ᴱ⟨⟩-mono✓; ⤇ᴱ⟨⟩-param; ⤇ᴱ⟨⟩-eatʳ; □ᵒ-elim;
  dup-□ᵒ)
open import Syng.Model.Prop.Basic using (⸨_⸩ᴮ; ⸨⸩ᴮ-Mono)
open import Syng.Model.Prop.Smry using (Smry; Smry-0; Smry-add-š; Smry-rem-<;
  Smry-back)
open import Syng.Model.Prop.Names using ([^_]ᴺᵒ; [^]ᴺᵒ-no2)
open import Syng.Model.Prop.Inv using (Binv; &ⁱ⟨_⟩ᵒ_; Kinv; ⅋ⁱ⟨_⟩ᵒ_; dup-&ⁱᵒ;
  Kinv-no2; &ⁱᵒ-Kinv-new; Binv-agree; Kinv-agree)
open import Syng.Model.Prop.Interp using (⸨_⸩; ⸨⸩-Mono; ⸨⸩-ᴮ⇒)
open import Syng.Model.Prop.Sound using (⊢-sem)
open import Syng.Model.Fupd.Base using ([_]⇛ᵍ¹_; ⇛ᵍ-mono✓; ⊨✓⇒⊨-⇛ᵍ; ⇛ᵍ¹-make;
  ⇛ᵍ¹-intro; ⇛ᵍ-eatˡ)

private variable
  ł :  Level
  i :  ℕ
  nm :  Name
  P :  SProp∞
  Pᵒ :  SPropᵒ ł

--------------------------------------------------------------------------------
-- Fancy update on Invᴱᴿᴬ

-- Lineᴵⁿᵛ :  Line for Invᴵⁿᵛ

Lineᴵⁿᵛ :  ℕ →  Name →  SProp∞ →  SPropᵒ 1ᴸ
Lineᴵⁿᵛ i nm P =  Kinv i nm P ∗ᵒ ⸨ P ⸩  ⨿ᵒ  [^ nm ]ᴺᵒ

-- Invᴵⁿᵛ :  Invariant for Invᴱᴿᴬ

Invᴵⁿᵛ :  Envᴵⁿᵛ →  SPropᵒ 1ᴸ
Invᴵⁿᵛ (ⁿPˇ˙ , n) =  Smry (uncurry ∘ Lineᴵⁿᵛ) ⁿPˇ˙ n

-- ⇛ᴵⁿᵛ :  Fancy update on Invᴱᴿᴬ

infix 3 ⇛ᴵⁿᵛ_
⇛ᴵⁿᵛ_ :  SPropᵒ ł →  SPropᵒ (1ᴸ ⊔ᴸ ł)
⇛ᴵⁿᵛ Pᵒ =  [ jᴵⁿᵛ , Invᴵⁿᵛ ]⇛ᵍ¹ Pᵒ

abstract

  -- Get Invᴵⁿᵛ (∅ᴵⁿᴳ jᴵⁿᵛ) for free

  Invᴵⁿᵛ-∅ :  ⊨ Invᴵⁿᵛ (∅ᴵⁿᴳ jᴵⁿᵛ)
  Invᴵⁿᵛ-∅ =  Smry-0

  -- Introduce ⇛ᴵⁿᵛ

  ⇛ᴵⁿᵛ-intro :  Pᵒ  ⊨ ⇛ᴵⁿᵛ  Pᵒ
  ⇛ᴵⁿᵛ-intro =  ⇛ᵍ¹-intro

  -- Get &ⁱ⟨ nm ⟩ᵒ P by storing ⸨ P ⸩ minus &ⁱ⟨ nm ⟩ᵒ ⸨ P ⸩

  &ⁱᵒ-new-rec :  &ⁱ⟨ nm ⟩ᵒ P -∗ᵒ ⸨ P ⸩  ⊨ ⇛ᴵⁿᵛ  &ⁱ⟨ nm ⟩ᵒ P
  &ⁱᵒ-new-rec {P = P} =  ⇛ᵍ¹-make $ ?∗ᵒ-intro &ⁱᵒ-Kinv-new ›
    -- (&∗Kinv)∗(&-*P)*Inv → → (&∗&∗Kinv)∗(&-*P)*Inv → →
    -- &∗((&∗Kinv)∗(&-*P))*Inv → → &∗(Kinv∗&∗(&-*P))*Inv → &∗(Kinv∗P)∗Inv → →
    -- &∗Inv
    ⤇ᴱ⟨⟩-eatʳ › ⤇ᴱ⟨⟩-mono✓ (λ _ ✓∙ → ∗ᵒ-monoˡ (∗ᵒ-monoˡ dup-&ⁱᵒ › ∗ᵒ-assocʳ) ›
      ∗ᵒ-assocʳ › ∗ᵒ-mono✓ʳ (λ ✓∙ → ∗ᵒ-assocˡ › ∗ᵒ-mono✓ˡ (λ ✓∙ →
      ∗ᵒ-monoˡ ∗ᵒ-comm › ∗ᵒ-assocʳ › ∗ᵒ-mono✓ʳ (-∗ᵒ-applyˡ $ ⸨⸩-Mono {P}) ✓∙ ›
      ĩ₀_) ✓∙ › Smry-add-š) ✓∙) › ⤇ᴱ⟨⟩-param

  -- Store [^ nm ]ᴺᵒ to get Kinv i nm P and ⸨ P ⸩ under Lineᴵⁿᵛ

  [^]ᴺᵒ-open :  [^ nm ]ᴺᵒ  ∗ᵒ  Lineᴵⁿᵛ i nm P  ⊨✓
                  (Kinv i nm P  ∗ᵒ  ⸨ P ⸩)  ∗ᵒ  Lineᴵⁿᵛ i nm P
  [^]ᴺᵒ-open ✓∙ =  ∗ᵒ⨿ᵒ-out › λ{
    (ĩ₀ [nm]∗Kinv∗P) →  [nm]∗Kinv∗P ▷ ∗ᵒ-comm ▷ ∗ᵒ-monoʳ ĩ₁_;
    (ĩ₁ [nm]∗[nm]) →  [nm]∗[nm] ▷ [^]ᴺᵒ-no2 ✓∙ ▷ λ () }

  -- Store Binv i nm P and [^ nm ]ᴺᵒ to get ⸨ P ⸩ and Kinv i nm P

  Binv-open :  [^ nm ]ᴺᵒ  ∗ᵒ  Binv i nm P  ⊨ ⇛ᴵⁿᵛ  ⸨ P ⸩  ∗ᵒ  Kinv i nm P
  Binv-open =  ∗ᵒ-comm › ⇛ᵍ¹-make $ ∗ᵒ-assocʳ › ∗ᵒ-monoˡ Binv-agree › ⤇ᴱ⟨⟩-eatʳ
    -- Binv∗[nm]∗Inv → [nm]∗Inv → [nm]∗Line∗Inv → ([nm]∗Line)∗Inv →
    -- ((Kinv∗P)∗Line)∗Inv → (Kinv∗P)∗Line∗Inv → (P∗Kinv)∗Inv
    › ⤇ᴱ⟨⟩-mono✓ (λ (i<n , ≡šR) ✓∙ → ∗ᵒ-elimʳ ∗ᵒ-Mono ›
      ∗ᵒ-monoʳ (Smry-rem-< i<n ≡šR) › ∗ᵒ-assocˡ › ∗ᵒ-mono✓ˡ [^]ᴺᵒ-open ✓∙ ›
      ∗ᵒ-assocʳ › ∗ᵒ-mono ∗ᵒ-comm (Smry-back ≡šR)) › ⤇ᴱ⟨⟩-param

  -- Store &ⁱ⟨ nm ⟩ᵒ P and [^ nm ]ᴺᵒ to get ⸨ P ⸩ and ⅋ⁱ⟨ nm ⟩ᵒ P

  &ⁱᵒ-open :  [^ nm ]ᴺᵒ  ∗ᵒ  &ⁱ⟨ nm ⟩ᵒ P  ⊨ ⇛ᴵⁿᵛ  ⸨ P ⸩  ∗ᵒ  ⅋ⁱ⟨ nm ⟩ᵒ P
  &ⁱᵒ-open =  ∗ᵒ⇒∗ᵒ' › λ{ (-, -, ∙⊑ , [nm]b , -, Q , -ᴵ, -, (Q∗R⊢P , Q∗P⊢R) ,
    □Q∗InvRc) → let MonoQ = ⸨⸩ᴮ-Mono {Q} in
    -- [nm]∗□Q∗Binv → → → □Q∗R∗Kinv → → → → (Q∗Q)∗R∗Kinv → → →
    -- (Q∗R)∗Q∗Kinv → P∗Q∗Kinv → P∗⅋
    ∗ᵒ'⇒∗ᵒ (-, -, ∙⊑ , [nm]b , □Q∗InvRc) ▷ ?∗ᵒ-comm ▷ ∗ᵒ-monoʳ Binv-open ▷
    ⇛ᵍ-eatˡ ▷ ⇛ᵍ-mono✓ λ ✓∙ → ∗ᵒ-monoˡ (dup-□ᵒ MonoQ ›
    ∗ᵒ-mono (□ᵒ-elim MonoQ › ⸨⸩-ᴮ⇒ {Q}) (□ᵒ-elim MonoQ)) › ∗ᵒ-assocʳ ›
    ∗ᵒ-monoʳ ?∗ᵒ-comm › ∗ᵒ-assocˡ › ∗ᵒ-mono✓ˡ (⊢-sem Q∗R⊢P) ✓∙ › ∗ᵒ-monoʳ
    λ big → -, Q , -ᴵ, -, Q∗P⊢R , big }

  -- Store Kinv i nm P and ⸨ P ⸩ to get [^ nm ]ᴺᵒ under Lineᴵⁿᵛ

  Kinv-close' :  (Kinv i nm P  ∗ᵒ  ⸨ P ⸩)  ∗ᵒ  Lineᴵⁿᵛ i nm P  ⊨✓
                   [^ nm ]ᴺᵒ  ∗ᵒ  Lineᴵⁿᵛ i nm P
  Kinv-close' ✓∙ =  ∗ᵒ⨿ᵒ-out › λ{
    (ĩ₀ Kinv∗P²) →  Kinv∗P² ▷ ∗ᵒ-assocˡ ▷
      ∗ᵒ-mono✓ˡ (λ ✓∙ → ∗ᵒ?-comm › ∗ᵒ-mono✓ˡ Kinv-no2 ✓∙ › ∗ᵒ⇒∗ᵒ') ✓∙ ▷
      ∗ᵒ⇒∗ᵒ' ▷ λ ();
    (ĩ₁ Kinv∗P∗[nm]) →  Kinv∗P∗[nm] ▷ ∗ᵒ-comm ▷ ∗ᵒ-monoʳ ĩ₀_ }

  -- Store ⸨ P ⸩ and Kinv i nm P to get [^ nm ]ᴺᵒ

  Kinv-close :  ⸨ P ⸩  ∗ᵒ  Kinv i nm P  ⊨ ⇛ᴵⁿᵛ  [^ nm ]ᴺᵒ
  Kinv-close =  ∗ᵒ-comm › ⇛ᵍ¹-make $ ∗ᵒ-assocʳ › ∗ᵒ-monoˡ Kinv-agree ›
    ⤇ᴱ⟨⟩-eatʳ › ⤇ᴱ⟨⟩-mono✓ (λ (i<n , ≡šR) ✓∙ →
      -- Kinv∗P∗Inv → (Kinv∗P)∗Inv → (Kinv∗P)∗Line∗Inv → ((Kinv∗P)∗Line)∗Inv →
      -- ([nm]∗Line)∗Inv → [nm]∗Line∗Inv → [nm]∗Inv
      ∗ᵒ-assocˡ › ∗ᵒ-monoʳ (Smry-rem-< i<n ≡šR) › ∗ᵒ-assocˡ ›
      ∗ᵒ-mono✓ˡ Kinv-close' ✓∙ › ∗ᵒ-assocʳ › ∗ᵒ-monoʳ $ Smry-back ≡šR) ›
    ⤇ᴱ⟨⟩-param

  -- Store ⸨ P ⸩ and ⅋ⁱ⟨ nm ⟩ᵒ P to get [^ nm ]ᴺᵒ

  ⅋ⁱᵒ-close :  ⸨ P ⸩  ∗ᵒ  ⅋ⁱ⟨ nm ⟩ᵒ P  ⊨ ⇛ᴵⁿᵛ  [^ nm ]ᴺᵒ
  ⅋ⁱᵒ-close =  ∗ᵒ⇒∗ᵒ' › λ{ (-, -, ∙⊑ , Pb , -, Q , -ᴵ, -, Q∗P⊢R , Q∗Kinvc) →
    -- P∗Q∗Kinv → Q∗P∗Kinv → (Q∗P)∗Kinv → → R∗Kinv
    ∗ᵒ'⇒∗ᵒ (-, -, ∙⊑ , Pb , Q∗Kinvc) ▷ ⊨✓⇒⊨-⇛ᵍ λ ✓∙ → ?∗ᵒ-comm › ∗ᵒ-assocˡ ›
    ∗ᵒ-mono✓ˡ (λ ✓∙ → ∗ᵒ-monoˡ (⸨⸩-ᴮ⇒ {Q}) › ⊢-sem Q∗P⊢R ✓∙) ✓∙ › Kinv-close }
