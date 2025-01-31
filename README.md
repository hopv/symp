# Syng

**Syng** is **concurrent separation logic** with **propositional ghost state**,
**fully mechanized** in Agda.

Syng supports **propositional ghost state**, which brings powerful expressivity,
just like an existing separation logic [**Iris**](https://iris-project.org/)
(Jung et al., 2015).  
Notably, Syng supports **propositional invariants** (a.k.a. impredicative
invariants).

But in contrast to Iris's *fully semantic* approach, Syng models the
propositional ghost state simply using the logic's **syntax** (for propositions
and judgments).

As a result, while Iris suffers from *step indexing* everywhere, Syng is **not
step-indexed at all**.  
Thanks to that, Syng has intuitive, easy-to-extend semantics and can flexibly
support **termination-sensitive** program reasoning.

Syng is mechanized in [**Agda**](https://agda.readthedocs.io/en/latest/), a
modern, dependently typed programming language.  
Agda is chosen here rather than [Coq](https://coq.inria.fr/),
[Lean](https://leanprover.github.io/), etc., because Agda has excellent support
of coinduction enabled by
[**sized types**](https://agda.readthedocs.io/en/latest/language/sized-types.html),
and Syng's approach takes great advantage of that.

## Getting Started

Just [install Agda](https://agda.readthedocs.io/en/latest/getting-started/installation.html).
Syng is known to work with Agda 2.6.2.2.  
Syng has no dependencies on external libraries.

### Agda Mode

For viewing and editing Agda code, you can use **Agda mode**
for [Emacs](https://agda.readthedocs.io/en/latest/tools/emacs-mode.html)
or [VS Code](https://marketplace.visualstudio.com/items?itemName=banacorn.agda-mode).

When you open an Agda file, you should first *load the file* (`Ctrl-c Ctrl-l` in
Emacs and VS Code), which loads and type-checks the contents of the file and
its dependencies.

Also, you can quickly jump to the definition (`Meta-.` in Emacs and `F12` in VS
Code) of any identifiers, including those that use symbols.

### Fonts

Syng's source code uses a lot of Unicode characters.  
To render them beautifully, we recommend you use monospace Unicode fonts that
support these characters, such as the following:
- [**JuliaMono**](https://juliamono.netlify.app/) ― Has a huge Unicode cover,
    including all the characters used in Syng's source code.
- [**Menlo**](https://en.wikipedia.org/wiki/Menlo_(typeface)) ― Is preinstalled
    on Mac and pretty beautiful. Doesn't support some characters (e.g., `⊢`).

For example, in VS Code, you can use the following setting (in `settings.json`)
to use Menlo as the primary font and fill in some gaps with JuliaMono.
```json
"editor.fontFamily": "Menlo, JuliaMono"
```

### Learning Agda

You can learn Agda's language features from
[the official document](https://agda.readthedocs.io/en/latest/language/index.html).

Here are notable features used in Syng.
- [**Sized types**](https://agda.readthedocs.io/en/latest/language/sized-types.html) ―
    Enable flexible coinduction and induction, especially in combination with
    [thunks and shrunks](src/Base/Size.agda).
- [**With-abstractions**](https://agda.readthedocs.io/en/latest/language/with-abstraction.html) ―
    Allow case analysis on calculated values.
- [**Copatterns**](https://agda.readthedocs.io/en/latest/language/copatterns.html) ―
    Get access to a component of records like a pattern.
- [**Record modules**](https://agda.readthedocs.io/en/latest/language/record-types.html#record-modules) ―
    Extend record types with derived notions, effectively used by the type
    [`ERA`](src/Syng/Model/ERA/Base.agda).

## Source Code

In the folder [`src`](src/) is the Agda source code for Syng.

### [`Base/`](src/Base/)

In [`Base/`](src/Base/) is a **general-purpose library** (though newly developed
for Syng).
Some of them re-export Agda's built-in libraries, possibly with renaming.
The library consists of the following parts.

- **Basics** ―
    [`Level`](src/Base/Level.agda) for universe levels;
    [`Func`](src/Base/Func.agda) for functions;
    [`Few`](src/Base/Eq.agda) for two-, one- and zero-element sets;
    [`Eq`](src/Base/Eq.agda) for equality;
    [`Dec`](src/Base/Dec.agda) for decidability;
    [`Acc`](src/Base/Acc.agda) for accessibility;
    [`Size`](src/Base/Size.agda) for sizes (modeling ordinals), thunks and
    shrunks.
- **Data types** ―
    [`Bool`](src/Base/Bool.agda) for Booleans;
    [`Zoi`](src/Base/Zoi.agda) for zoi (zero, one, or infinity) numbers;
    [`Option`](src/Base/Option.agda) for option types;
    [`Prod`](src/Base/Prod.agda) for sigma and product types;
    [`Sum`](src/Base/Sum.agda) for sum types;
    [`Nat`](src/Base/Nat.agda) for natural numbers;
    [`Natp`](src/Base/Natp.agda) for positive natural numbers;
    [`List`](src/Base/List.agda) for singly linked lists;
    [`Seq`](src/Base/Seq.agda) for infinite sequences;
    [`Str`](src/Base/Str.agda) for characters and strings;
    [`Ratp`](src/Base/Ratp.agda) for positive rational numbers.
- **Misc** ― [`Sety`](src/Base/Sety.agda) for syntactic sets.

### [`Syng/`](src/Syng/)

In [`Syng/`](src/Syng/) is **the heart of Syng**, which consists of the
following parts.
- [`Lang/`](src/Syng/Lang/) ― **The target language of Syng.**
    + [`Expr`](src/Syng/Lang/Expr.agda) for addresses, types and expressions;
        [`Ktxred`](src/Syng/Lang/Ktxred.agda) for evaluation contexts and
        redexes;
        [`Reduce`](src/Syng/Lang/Reduce.agda) for reduction of expressions.
    + [`Example`](src/Syng/Lang/Example.agda) for examples.
- [`Logic/`](src/Syng/Logic/) ― **The syntax of the separation logic Syng.**
    + [`Prop`](src/Syng/Logic/Prop.agda) for propositions;
        [`Judg`](src/Syng/Logic/Judg.agda) for judgments.
    + [`Core`](src/Syng/Logic/Core.agda) for core proof rules;
        [`Names`](src/Syng/Logic/Names.agda) for the name set token;
        [`Fupd`](src/Syng/Logic/Fupd.agda) for the fancy update;
        [`Hor`](src/Syng/Logic/Fupd.agda) for the Hoare triple;
        [`Heap`](src/Syng/Logic/Heap.agda) for the heap;
        [`Ind`](src/Syng/Logic/Ind.agda) for the indirection modality and the
        precursors;
        [`Inv`](src/Syng/Logic/Inv.agda) for the propositional invariant;
        [`Lft`](src/Syng/Logic/Lft.agda) for the lifetime;
        [`Bor`](src/Syng/Logic/Bor.agda) for the borrow;
        [`Ub`](src/Syng/Logic/Ub.agda) for the upper bound.
    + [`Paradox`](src/Syng/Logic/Paradox.agda) for paradoxes on plausible proof
        rules.
    + [`Example`](src/Syng/Logic/Example.agda) for examples.
- [`Model/`](src/Syng/Model/) ― **The semantic model and soundness proof of
    Syng.**
    + [`ERA/`](src/Syng/Model/ERA/) ― **Environmental resource algebras (ERAs),
        for modeling the ghost state of Syng.**
        * [`Base`](src/Syng/Model/ERA/Base.agda) for the basics of the ERA;
            [`All`](src/Syng/Model/ERA/All.agda) for the dependent-map ERA;
            [`Bnd`](src/Syng/Model/ERA/Bnd.agda) for the bounded-map ERA;
            [`Fin`](src/Syng/Model/ERA/Fin.agda) for the finite-map ERA.
        * Basic ERAs ―
            [`Zoi`](src/Base/Zoi.agda) for the zoi ERA;
            [`Exc`](src/Syng/Model/ERA/Exc.agda) for the exclusive ERA;
            [`Ag`](src/Syng/Model/ERA/Ag.agda) for the agreement ERA;
            [`FracAg`](src/Syng/Model/ERA/FracAg.agda) for the fractional
            agreement ERA.
        * Tailored ERAs ―
            [`Heap`](src/Syng/Model/ERA/Heap.agda) for the heap ERA;
            [`Names`](src/Syng/Model/ERA/Names.agda) for the name set ERA;
            [`Ind`](src/Syng/Model/ERA/Ind.agda) for the indirection ERAs;
            [`Inv`](src/Syng/Model/ERA/Inv.agda) for the invariant ERA;
            [`Lft`](src/Syng/Model/ERA/Lft.agda) for the lifetime ERA;
            [`Bor`](src/Syng/Model/ERA/Bor.agda) for the borrow ERA;
            [`Ub`](src/Syng/Model/ERA/Ub.agda) for the upper bound ERA.
        * Global ERA ―
            [`Glob`](src/Syng/Model/ERA/Glob.agda) for the global ERA.
    + [`Prop/`](src/Syng/Model/Prop/) ― **The semantic model of the propositions
        and the semantic soundness of the pure sequent.**
        * [`Base`](src/Syng/Model/Prop/Base.agda) for the core semantic logic
            connectives;
            [`Smry`](src/Syng/Model/Prop/Smry.agda) for the map summary;
            [`Names`](src/Syng/Model/Prop/Names.agda) for the name set token;
            [`Heap`](src/Syng/Model/Prop/Heap.agda) for the heap-related tokens;
            [`Lft`](src/Syng/Model/Prop/Lft.agda) for the lifetime-related
            tokens;
            [`Ub`](src/Syng/Model/Prop/Ub.agda) for the upper bound-related
            tokens.
        * [`Basic`](src/Syng/Model/Prop/Basic.agda) for basic propositions;
            [`Ind`](src/Syng/Model/Prop/Ind.agda) for the indirection modality
            and precursors;
            [`Inv`](src/Syng/Model/Prop/Inv.agda) for the invariant-related
            tokens;
            [`Bor`](src/Syng/Model/Prop/Bor.agda) for the borrow-related tokens.
        * [`Interp`](src/Syng/Model/Prop/Interp.agda) for the semantics of all
            the propositions;
            [`Sound`](src/Syng/Model/Prop/Sound.agda) for the semantic soundness
            and adequacy of the logic's pure sequent.
    + [`Fupd/`](src/Syng/Model/Fupd/) ― **The semantic model and soundness proof
        of the fancy update.**
        * [`Base`](src/Syng/Model/Fupd/Base.agda) for the general fancy update;
            [`Ind`](src/Syng/Model/Fupd/Ind.agda) for the fancy update on the
            indirection modality and precursors;
            [`Inv`](src/Syng/Model/Fupd/Inv.agda) for the fancy update on the
            propositional invariant;
            [`Bor`](src/Syng/Model/Fupd/Bor.agda) for the fancy update on the
            borrow.
        * [`Interp`](src/Syng/Model/Prop/Interp.agda) for interpreting the fancy
            update;
          [`Sound`](src/Syng/Model/Fupd/Sound.agda) for the semantic soundness
            and adequacy of the logic's fancy update sequent.
    + [`Hor/`](src/Syng/Model/Hor/) ― **The semantic model and soundness proof
        of the Hoare triples.**
        * [`Wp`](src/Syng/Model/Hor/Wp.agda) for the semantic weakest
            preconditions;
          [`Lang`](src/Syng/Model/Hor/Lang.agda) for language-specific lemmas on
            the weakest preconditions;
          [`Heap`](src/Syng/Model/Hor/Heap.agda) for semantic fancy update and
            weakest precondition lemmas for the heap.
        * [`Adeq`](src/Syng/Model/Hor/Adeq.agda) for the adequacy of the
            semantic weakest preconditions.
        * [`Sound`](src/Syng/Model/Hor/Sound.agda) for the semantic soundness
            and adequacy of the logic's Hoare triple.

We also have [`All`](src/Syng/All.agda) for just importing all the relevant
parts of Syng.

## Meta-logic

As the meta-logic of Syng, we use **Agda**, under the option
**`--without-K --sized-types`**, **without any extra axioms**.

Our meta-logic has the following properties.
- We **use only predicative universes** and don't use any *impredicative
    universes* like Coq's `Prop`.
- We **don't use any classical or choice axioms**.
- We **don't use the axiom K**, an axiom incompatible with the **univalence**
    axiom.
- We don't use any proof-irrelevant types like types in Coq's `Prop`.
- We use **sized types** for flexible coinduction and induction.
    + Although some concerns about Agda's soundness around sized types exist,
        the semantics of sized types are pretty clear in theory. In Syng's 
        mechanization, we use sized types carefully, avoiding unsoundness.

## Termination verification by induction

Syng has two types of Hoare triples, **partial** and **total**.  
The partial Hoare triple allows coinductive reasoning but does not ensure
termination.  
The total Hoare triple allows only **inductive reasoning** and thus ensures
termination.

### Why termination verification is tough in step-indexed logics

In **step-indexed logics** like Iris, roughly speaking, a Hoare triple *can only
be partial*.  
They strip one *later modality* `▷` off per program step, which destines their
reasoning to be *coinductive*, due to Löb induction.  
This makes termination verification in such logics fundamentally challenging.

Let's see this more in detail.  
Suppose the target language has an expression constructor `▶`, such that `▶ e`
reduces to `e` in one program step.  
We have the following Hoare triple rule for `▶` in step-indexed logics like
Iris, because **one later modality is stripped off per program step**.
```
▷ { P } e { Q }  ⊢  { P } ▶ e { Q }
```
Intuitively, `▷ P`, `P` under the *later modality* `▷`, means that `P` holds
after one *logical* step.

Also, suppose we can make a vacuous loop `▶ ▶ ▶ …` of `▶`s.  
By the rule for `▶`, we get the following lemma on `▶ ▶ ▶ …`.
```
▷ { P } ▶ ▶ ▶ … { Q }  ⊢  { P } ▶ ▶ ▶ … { Q }
```

On the other hand, a step-indexed logic has the following rule called **Löb
induction**.
```
▷ P ⊢ P
-------
  ⊢ P
```
If we can get `P` assuming `▷ P` (or intuitively, `P` after one logical step),
then we can get just `P`.

Combining Löb induction with the previous lemma, we can have a Hoare triple for
`▶ ▶ ▶ …` without any premise.
```
⊢  { P } ▶ ▶ ▶ … { Q }
```
This means that *the Hoare triple is partial*, not total, as executing the loop
`▶ ▶ ▶ …` does not terminate.  
Essentially, this is due to *coinduction introduced by the later modality*.

For this reason, Iris does not generally support termination verification.

[Transfinite Iris](https://iris-project.org/transfinite-iris/) (Spies et al.,
2021), a variant of Iris with step-indexing over ordinal numbers, supports *time
credits with ordinals* for termination verification.  
However, to use this, one should do *careful math of ordinals*, which is a
demanding task and formally requires *classical and choice axioms*.

On the other hand, our logic, Syng, simply provides the **total** Hoare triple
with **inductive** deduction, thanks to being **non-step-indexed**.  
Remarkably, termination verification in Syng can **take advantage of Agda's
termination checker**, which is handy, flexible and expressive.

## Verifying richer liveness properties

Because Syng is not step-indexed, it has the potential to verify **liveness
properties** of programs in general, not just termination.

To demonstrate this, the current version of Syng has the **infinite Hoare
triple**.  
It ensures that an observable event occurs an infinite number of times in any
execution of the program.  
This property, apparently simple, is actually characterized as the **mixed fixed
point**, or more specifically, the greatest fixed point over the least fixed
point.  
For the infinite Hoare triple, usually the hypothesis can be used only
*inductively*, but when the event is triggered, the hypothesis can be used
*coinductively*.  
In this way, this judgment is defined **coinductively-inductively**, which
naturally ensures an infinite number of occurrences of the event.

As a future extension, Syng can be combined with the approach of
[**Simuliris**](https://iris-project.org/pdfs/2022-popl-simuliris.pdf) (Gäher et
al., 2022).  
Syng is a logic for verifying **fair termination preservation** (i.e.,
preservation of termination under any fair thread scheduling) of various
optimizations of concurrent programs.  
Fair termination preservation is an applicable but tricky property, modeled 
**coinductively-inductively**.
For this reason, Simuliris is built on a **non-step-indexed** variant of Iris,
which has given up any kind of *propositional ghost state*, including
*propositional invariants*.  
We can build a logic for fair termination preservation *with* propositional
ghost state, simply by fusing Simuliris with our logic Syng.
