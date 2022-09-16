--------------------------------------------------------------------------------
-- General super update and invariant builder
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Syho.Model.Supd.Base where

open import Base.Level using (Level; _⊔ᴸ_; 2ᴸ)
open import Base.Func using (_$_; _▷_; _∘_; _›_)
open import Base.Few using (absurd)
open import Base.Eq using (_≡_; refl; ◠_; subst₂; _≡˙_)
open import Base.Dec using (yes; no; _≡?_; ≡?-refl; upd˙)
open import Base.Prod using (_×_; _,_)
open import Base.Option using (¿_; š_; ň)
open import Base.Nat using (ℕ; ṡ_; _≥_; _<_; _<ᵈ_; ≤-refl; <⇒≤; <-irrefl;
  ≤ᵈ-refl; ≤ᵈṡ; ≤ᵈ⇒≤; ≤⇒≤ᵈ)
open import Syho.Lang.Reduce using (Mem)
open import Syho.Model.Prop.Base using (Propᵒ; Monoᵒ; _⊨✓_; _⊨_; ∀ᵒ-syntax; ⊤ᵒ;
  _∗ᵒ_; _-∗ᵒ_; ⤇ᵒ_; _⤇ᴱ_; ⊨⇒⊨✓; ∀ᵒ-Mono; ∀ᵒ-mono; ∀ᵒ-intro; ∗ᵒ-Mono; ∗ᵒ-mono✓ˡ;
  ∗ᵒ-mono✓ʳ; ∗ᵒ-monoˡ; ∗ᵒ-monoʳ; ∗ᵒ-comm; ∗ᵒ-assocˡ; ∗ᵒ-assocʳ; ?∗ᵒ-comm;
  -∗ᵒ-Mono; -∗ᵒ-monoʳ; -∗ᵒ-intro; -∗ᵒ-apply; ⤇ᵒ-intro; ⤇ᴱ-Mono; ⤇ᴱ-mono✓;
  ⤇ᴱ-mono; ⤇ᴱ-respᴱˡ; ⤇ᴱ-respᴱʳ; ⤇ᴱ-param; ⤇ᵒ⇒⤇ᴱ; ⤇ᵒ-eatʳ; ⤇ᴱ-join; ⤇ᴱ-eatˡ;
  ⤇ᴱ-eatʳ)
open import Syho.Model.ERA.Glob using (Envᴵⁿᴳ; envᴳ; envᴳ-cong)

private variable
  ł ł' ł'' :  Level
  X :  Set ł
  Pᵒ Qᵒ :  Propᵒ ł
  M M' M'' :  Mem
  E :  Envᴵⁿᴳ
  gsI :  (Envᴵⁿᴳ → X) × (X → Envᴵⁿᴳ → Envᴵⁿᴳ) × (X → Propᵒ ł)
  get get' :  Envᴵⁿᴳ → X
  set set' :  X → Envᴵⁿᴳ → Envᴵⁿᴳ
  Inv Inv' F :  X → Propᵒ ł
  i n :  ℕ
  xˇ˙ yˇ˙ :  ℕ → ¿ X
  xˇ :  ¿ X
  x y :  X

--------------------------------------------------------------------------------
-- [ ]⇛ᵍ :  General super-update modality

-- Parametrized over the getter (get) and setter (set) on the environment and
-- the invariant predicate (Inv)

abstract

  infix 8 ⟨_⟩[_]⇛ᵍ⟨_⟩_
  ⟨_⟩[_]⇛ᵍ⟨_⟩_ :  ∀{X : Set ł} →
    Mem →  (Envᴵⁿᴳ → X) × (X → Envᴵⁿᴳ → Envᴵⁿᴳ) × (X → Propᵒ ł') →
    Mem →  Propᵒ ł'' →  Propᵒ (2ᴸ ⊔ᴸ ł ⊔ᴸ ł' ⊔ᴸ ł'')
  ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M' ⟩ Pᵒ =  ∀ᵒ E ,
    Inv (get E) -∗ᵒ envᴳ M E ⤇ᴱ λ x → envᴳ M' $ set x E , Pᵒ ∗ᵒ Inv x

  -- Monoᵒ for ⇛ᵍ

  ⇛ᵍ-Mono :  Monoᵒ $ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Pᵒ
  ⇛ᵍ-Mono =  ∀ᵒ-Mono λ _ → -∗ᵒ-Mono

  -- Monotonicity of ⇛ᵍ

  ⇛ᵍ-mono✓ :  Pᵒ ⊨✓ Qᵒ →  ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Pᵒ ⊨ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Qᵒ
  ⇛ᵍ-mono✓ P⊨✓Q gsI⇛P E =  (-∗ᵒ-monoʳ $ ⤇ᴱ-mono✓ λ _ → ∗ᵒ-mono✓ˡ P⊨✓Q) $ gsI⇛P E

  ⇛ᵍ-mono :  Pᵒ ⊨ Qᵒ →  ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Pᵒ ⊨ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Qᵒ
  ⇛ᵍ-mono =  ⇛ᵍ-mono✓ ∘ ⊨⇒⊨✓

  -- Utility for making ⇛ᵍ

  ⇛ᵍ-make :  (∀ E →  Pᵒ ∗ᵒ Inv (get E) ⊨✓
               envᴳ M E ⤇ᴱ λ x → envᴳ M' $ set x E , Qᵒ ∗ᵒ Inv x) →
             Pᵒ ⊨ ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M' ⟩ Qᵒ
  ⇛ᵍ-make {Pᵒ = Pᵒ} Inv∗P⊨✓⤇Inv∗Q =
    ∀ᵒ-intro {Pᵒ = Pᵒ} λ _ → -∗ᵒ-intro λ ✓∙ → ∗ᵒ-comm › Inv∗P⊨✓⤇Inv∗Q _ ✓∙

  -- Apply ⇛ᵍ

  ⇛ᵍ-apply :  ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M' ⟩ Pᵒ ∗ᵒ Inv (get E) ⊨✓
                envᴳ M E ⤇ᴱ λ x → envᴳ M' $ set x E , Pᵒ ∗ᵒ Inv x
  ⇛ᵍ-apply ✓∙ =  ∗ᵒ-monoˡ (_$ _) › ∗ᵒ-comm › -∗ᵒ-apply ⤇ᴱ-Mono ✓∙

  -- ⊨✓ ⇛ᵍ into ⊨ ⇛ᵍ

  ⊨✓⇛ᵍ⇒⊨⇛ᵍ :  Pᵒ ⊨✓ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Qᵒ →  Pᵒ ⊨ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Qᵒ
  ⊨✓⇛ᵍ⇒⊨⇛ᵍ {Pᵒ = Pᵒ} P⊨✓⇛Q =  ⇛ᵍ-make {Pᵒ = Pᵒ} λ _ ✓∙ →
    ∗ᵒ-mono✓ˡ P⊨✓⇛Q ✓∙ › ⇛ᵍ-apply ✓∙

  -- Introduce ⇛ᵍ

  ⤇ᵒ⇒⇛ᵍ :  (∀{E} → set (get E) E ≡˙ E) →
           ⤇ᵒ Pᵒ ⊨ ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M ⟩ Pᵒ
  ⤇ᵒ⇒⇛ᵍ setget≡ =  ⇛ᵍ-make λ _ _ →
    ⤇ᵒ-eatʳ › ⤇ᵒ⇒⤇ᴱ › ⤇ᴱ-respᴱˡ (envᴳ-cong setget≡) › ⤇ᴱ-param

  ⇛ᵍ-intro :  (∀{E} → set (get E) E ≡˙ E) →
              Pᵒ ⊨ ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M ⟩ Pᵒ
  ⇛ᵍ-intro setget≡ =  ⤇ᵒ-intro › ⤇ᵒ⇒⇛ᵍ setget≡

  -- Join the same ⇛ᵍs

  ⇛ᵍ-join :
    (∀{E x} → get (set x E) ≡ x) →  (∀{E x y} → set y (set x E) ≡˙ set y E) →
    ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M' ⟩ ⟨ M' ⟩[ get , set , Inv ]⇛ᵍ⟨ M'' ⟩ Pᵒ  ⊨
      ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M'' ⟩ Pᵒ
  ⇛ᵍ-join {Inv = Inv} getset≡ setset≡set =
    ⇛ᵍ-make {Pᵒ = ⟨ _ ⟩[ _ ]⇛ᵍ⟨ _ ⟩ _} λ E ✓∙ → ⇛ᵍ-apply ✓∙ ›
    ⤇ᴱ-mono✓ (λ _ ✓∙ → ∗ᵒ-monoʳ (subst₂ Inv (◠ getset≡ {E}) refl) › ⇛ᵍ-apply ✓∙)
    › ⤇ᴱ-join › ⤇ᴱ-respᴱʳ (envᴳ-cong setset≡set) › ⤇ᴱ-param

  -- Join two different ⇛ᵍs

  ⇛ᵍ-join2 :  (∀{E x} → get' (set x E) ≡ get' E) →
    ⟨ M ⟩[ get , set , Inv ]⇛ᵍ⟨ M' ⟩ ⟨ M' ⟩[ get' , set' , Inv' ]⇛ᵍ⟨ M'' ⟩ Pᵒ  ⊨
      ⟨ M ⟩[ (λ E → (get E , get' E)) , (λ (x , y) → set' y ∘ set x) ,
             (λ (x , y) → Inv x ∗ᵒ Inv' y) ]⇛ᵍ⟨ M'' ⟩ Pᵒ
  ⇛ᵍ-join2 {Inv' = Inv'} get'set≡get' =  ⇛ᵍ-make {Pᵒ = ⟨ _ ⟩[ _ ]⇛ᵍ⟨ _ ⟩ _}
    λ _ ✓∙ → ∗ᵒ-assocʳ › ∗ᵒ-mono✓ˡ ⇛ᵍ-apply ✓∙ › ⤇ᴱ-eatʳ › ⤇ᴱ-mono✓ (λ _ ✓∙ →
      ∗ᵒ-assocˡ › ∗ᵒ-monoʳ ∗ᵒ-comm › ∗ᵒ-assocʳ › ∗ᵒ-mono✓ˡ
        (λ ✓∙ → ∗ᵒ-monoʳ (subst₂ Inv' (◠ get'set≡get') refl) › ⇛ᵍ-apply ✓∙) ✓∙ ›
      ⤇ᴱ-eatʳ › ⤇ᴱ-mono λ _ → ∗ᵒ-assocˡ › ∗ᵒ-monoʳ ∗ᵒ-comm) › ⤇ᴱ-join

  -- Let ⇛ᵍ eat a proposition under ∗ᵒ

  ⇛ᵍ-eatˡ :  Pᵒ ∗ᵒ ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Qᵒ  ⊨  ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ (Pᵒ ∗ᵒ Qᵒ)
  ⇛ᵍ-eatˡ =  ⇛ᵍ-make {Pᵒ = _ ∗ᵒ _} λ _ ✓∙ → ∗ᵒ-assocˡ › ∗ᵒ-mono✓ʳ ⇛ᵍ-apply ✓∙ ›
    ⤇ᴱ-eatˡ › ⤇ᴱ-mono λ _ → ∗ᵒ-assocʳ

  ⇛ᵍ-eatʳ :  ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ Pᵒ ∗ᵒ Qᵒ  ⊨  ⟨ M ⟩[ gsI ]⇛ᵍ⟨ M' ⟩ (Pᵒ ∗ᵒ Qᵒ)
  ⇛ᵍ-eatʳ =  ∗ᵒ-comm › ⇛ᵍ-eatˡ › ⇛ᵍ-mono ∗ᵒ-comm

--------------------------------------------------------------------------------
-- Invᵍ :  General invariant bulder

abstract

  -- Invᵍ F xˇ˙ n :  xˇ˙ i interpreted with F, over all i < n

  Invᵍ :  (X → Propᵒ ł) →  (ℕ → ¿ X) →  ℕ →  Propᵒ (2ᴸ ⊔ᴸ ł)
  Invᵍ F xˇ˙ 0 =  ⊤ᵒ
  Invᵍ F xˇ˙ (ṡ n)  with xˇ˙ n
  … | ň =  Invᵍ F xˇ˙ n
  … | š y =  F y ∗ᵒ Invᵍ F xˇ˙ n

  -- Monoᵒ for ⸨ ⸩ᴺᵐ

  Invᵍ-Mono :  Monoᵒ $ Invᵍ F xˇ˙ n
  Invᵍ-Mono {n = 0} =  _
  Invᵍ-Mono {xˇ˙ = xˇ˙} {ṡ n'}  with xˇ˙ n'
  … | ň =  Invᵍ-Mono {n = n'}
  … | š _ =  ∗ᵒ-Mono

  -- Update an element out of the bound

  Invᵍ-⇒upd-≥ :  i ≥ n →  Invᵍ F yˇ˙ n  ⊨  Invᵍ F (upd˙ i xˇ yˇ˙) n
  Invᵍ-⇒upd-≥ {_} {0} =  _
  Invᵍ-⇒upd-≥ {i} {ṡ n'} {yˇ˙ = yˇ˙} i>n'  with n' ≡? i
  … | yes refl =  absurd $ <-irrefl i>n'
  … | no _  with yˇ˙ n'
  …   | š _ =  ∗ᵒ-monoʳ $ Invᵍ-⇒upd-≥ $ <⇒≤ i>n'
  …   | ň =  Invᵍ-⇒upd-≥ $ <⇒≤ i>n'

  -- Add a proposition at the bound

  Invᵍ-add-š :  F x ∗ᵒ Invᵍ F yˇ˙ n  ⊨  Invᵍ F (upd˙ n (š x) yˇ˙) (ṡ n)
  Invᵍ-add-š {n = n}  rewrite ≡?-refl {a = n} =
    ∗ᵒ-monoʳ $ Invᵍ-⇒upd-≥ $ ≤-refl {n}

  Invᵍ-add-ň :  Invᵍ F xˇ˙ n  ⊨  Invᵍ F (upd˙ n ň xˇ˙) (ṡ n)
  Invᵍ-add-ň {n = n}  rewrite ≡?-refl {a = n} =  Invᵍ-⇒upd-≥ $ ≤-refl {n}

  -- Remove an element within the bound to get the element's interpretation

  Invᵍ-rem-<ᵈ :  xˇ˙ i ≡ š y →  i <ᵈ n →
    Invᵍ F xˇ˙ n  ⊨  F y ∗ᵒ Invᵍ F (upd˙ i ň xˇ˙) n
  Invᵍ-rem-<ᵈ {i = i} xˇi≡šy ≤ᵈ-refl  rewrite xˇi≡šy =
    ∗ᵒ-monoʳ (Invᵍ-add-ň {n = i})
  Invᵍ-rem-<ᵈ {xˇ˙ = xˇ˙} {i} xˇi≡šy (≤ᵈṡ {n = n'} i<ᵈn')  with n' ≡? i
  … | yes refl =  absurd $ <-irrefl $ ≤ᵈ⇒≤ i<ᵈn'
  … | no _  with xˇ˙ n'
  …   | ň =  Invᵍ-rem-<ᵈ xˇi≡šy i<ᵈn'
  …   | š _ =  ∗ᵒ-monoʳ (Invᵍ-rem-<ᵈ xˇi≡šy i<ᵈn') › ?∗ᵒ-comm

  Invᵍ-rem-< :  xˇ˙ i ≡ š y →  i < n →
    Invᵍ F xˇ˙ n  ⊨  F y ∗ᵒ Invᵍ F (upd˙ i ň xˇ˙) n
  Invᵍ-rem-< xˇi≡šy =  Invᵍ-rem-<ᵈ xˇi≡šy ∘ ≤⇒≤ᵈ
