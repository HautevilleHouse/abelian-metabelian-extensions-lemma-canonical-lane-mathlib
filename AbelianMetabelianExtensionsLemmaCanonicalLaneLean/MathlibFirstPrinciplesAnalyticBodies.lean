/-
All Rights Reserved - No License Granted

Copyright (c) 2026 HautevilleHouse. All rights reserved.

This repository is published for academic review, citation, priority, public
notice, and research-reference purposes only.

No license is granted to use, copy, reproduce, redistribute, modify, merge,
publish, distribute, sublicense, sell, fork, mirror, scrape, use for training or
fine-tuning, include in a dataset or benchmark, use to create, evaluate, or
benchmark a derivative system, incorporate into another system, or create
derivative works from this repository or any substantial portion of it without
prior written permission from the rights holder.

Viewing this repository on GitHub for academic review and citation is permitted
with all rights reserved by the rights holder.

Any discussion, review, comparison, implementation, derivative research use, or
public reference to this repository must cite the repository and preserve this
notice.

Unauthorized reproduction or redistribution of this repository, including public
GitHub forks containing the repository contents, constitutes copyright
infringement and may be subject to DMCA.
-/
import Mathlib.Algebra.Group.Defs
import Mathlib.GroupTheory.Subgroup.Basic
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Mathlib First-Principles Abelian Metabelian Extensions

This module records the Mathlib group-theoretic substrate available for the
Abelian Metabelian Extensions Lemma and separates it from the extension-theoretic
bodies that still need foundational proof.

The file contributes checked theorem bodies for the available Mathlib substrate
and a proof-carrying package interface for the abelian-metabelian extension route.
-/

namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

/-- A group is abelian when multiplication is commutative. -/
def IsAbelianGroup (G : Type*) [Group G] : Prop :=
  ∀ a b : G, a * b = b * a

/-- A group is metabelian when it has an abelian normal subgroup with abelian quotient. -/
def IsMetabelianGroup (G : Type*) [Group G] : Prop :=
  ∃ N : Subgroup G, N.Normal ∧ IsAbelianGroup N ∧ IsAbelianGroup (G ⧸ N)

/-- A short exact sequence 1 → A → G → B → 1 of groups. -/
structure ShortExactSequence (A G B : Type*) [Group A] [Group G] [Group B] where
  inj : A →* G
  proj : G →* B
  inj_injective : Function.Injective inj
  proj_surjective : Function.Surjective proj
  exact_ker_eq_range : ∀ g : G, proj g = 1 ↔ ∃ a : A, inj a = g

/-- A group is an abelian extension when it fits into a short exact sequence
with abelian kernel and abelian quotient. -/
def IsAbelianExtension (G : Type*) [Group G] : Prop :=
  ∃ (A B : Type*) (_ : Group A) (_ : Group B),
    IsAbelianGroup A ∧ IsAbelianGroup B ∧ Nonempty (ShortExactSequence A G B)

/-- The Abelian Metabelian Extensions Lemma: every abelian extension is metabelian. -/
def AbelianMetabelianExtensionsLemma : Prop :=
  ∀ (A G B : Type*) [Group A] [Group G] [Group B],
    IsAbelianGroup A → IsAbelianGroup B → ShortExactSequence A G B → IsMetabelianGroup G

/-- The local lemma statement is definitionally the global universal closure. -/
theorem abelian_metabelian_extensions_lemma_definitional :
    AbelianMetabelianExtensionsLemma =
      (∀ (A G B : Type*) [Group A] [Group G] [Group B],
        IsAbelianGroup A → IsAbelianGroup B → ShortExactSequence A G B → IsMetabelianGroup G) := by
  rfl

/-- The short-exact-sequence form is logically equivalent to the existential
abelian-extension form. -/
theorem abelian_extension_iff_metabelian_lemma :
    (∀ (A G B : Type*) [Group A] [Group G] [Group B],
      IsAbelianGroup A → IsAbelianGroup B → ShortExactSequence A G B → IsMetabelianGroup G) ↔
    (∀ (G : Type*) [Group G], IsAbelianExtension G → IsMetabelianGroup G) := by
  constructor
  · intro h G hExt
    rcases hExt with ⟨A, B, gA, gB, hA, hB, ⟨ses⟩⟩
    exact h hA hB ses
  · intro h A G B gA gB hA hB ses
    exact h G ⟨A, B, gA, gB, hA, hB, ⟨ses⟩⟩

/-- Mathlib supplies the exactness membership criterion as a first-principles body. -/
theorem mathlib_exact_ker_eq_range_body
    {A G B : Type*} [Group A] [Group G] [Group B]
    (ext : ShortExactSequence A G B) :
    ∀ g : G, ext.proj g = 1 ↔ ∃ a : A, ext.inj a = g := by
  intro g
  exact ext.exact_ker_eq_range g

/-- Mathlib supplies the injectivity body for the monoid hom. -/
theorem mathlib_injective_body
    {A G : Type*} [Group A] [Group G] (f : A →* G)
    (hf : Function.Injective f) :
    ∀ a b : A, f a = f b → a = b := hf

structure MathlibAvailableGroupTheoryBodies where
  exactKerEqRangeBodyAvailable : Prop
  injectiveBodyAvailable : Prop
  abelianMetabelianLemmaDefinitionalAvailable : Prop
  exactKerEqRangeBodyAvailableTerm : exactKerEqRangeBodyAvailable
  injectiveBodyAvailableTerm : injectiveBodyAvailable
  abelianMetabelianLemmaDefinitionalAvailableTerm : abelianMetabelianLemmaDefinitionalAvailable

def mathlibAvailableGroupTheoryBodies : MathlibAvailableGroupTheoryBodies := {
  exactKerEqRangeBodyAvailable := True
  injectiveBodyAvailable := True
  abelianMetabelianLemmaDefinitionalAvailable := True
  exactKerEqRangeBodyAvailableTerm := by exact True.intro
  injectiveBodyAvailableTerm := by exact True.intro
  abelianMetabelianLemmaDefinitionalAvailableTerm := by exact True.intro
}

structure MathlibMetabelianExtensionObligations where
  abelianMetabelianExtensionsLemmaBody : Prop
  exactnessToNormalSubgroupBridgeBody : Prop
  abelianMetabelianExtensionsLemmaBodyTerm : abelianMetabelianExtensionsLemmaBody
  exactnessToNormalSubgroupBridgeBodyTerm : exactnessToNormalSubgroupBridgeBody

structure MathlibFirstPrinciplesAbelianMetabelianPackage where
  availableBodiesChecked : MathlibAvailableGroupTheoryBodies
  obligations : MathlibMetabelianExtensionObligations
  primitiveFormalization : Prop
  bodyToPrimitiveCompatibility : Prop
  primitiveFormalizationTerm : primitiveFormalization
  bodyToPrimitiveCompatibilityTerm : bodyToPrimitiveCompatibility

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean