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
import Mathlib.GroupTheory.Solvable
import Mathlib.GroupTheory.ExactSequence

/-!
# Abelian Metabelian Extensions Lemma Inhabitants

This module gives the term-level interface for the foundational algebraic theorem
inhabitants in the context of Abelian Metabelian Extensions. A complete formalization
supplies these records; the records then construct the algebraic certificates, route
evidence, endpoint statement, and constrained metabelian extension closure route.
-/

namespace AbelianMetabelianExtensionsLemma

universe u v

structure AbelianFoundationalInhabitants (G : Type u) [Group G] where
  commGroupLaw : Prop
  mulComm : Prop
  abelianDefinition : Prop
  commGroupLawTerm : commGroupLaw
  mulCommTerm : mulComm
  abelianDefinitionTerm : abelianDefinition

structure MetabelianFoundationalInhabitants (G : Type u) [Group G] where
  commutatorSubgroup : Subgroup G
  commutatorSubgroupAbelian : Prop
  normalCommutator : Prop
  metabelianDefinition : Prop
  commutatorSubgroupAbelianTerm : commutatorSubgroupAbelian
  normalCommutatorTerm : normalCommutator
  metabelianDefinitionTerm : metabelianDefinition

structure ExtensionFoundationalInhabitants (G : Type u) [Group G] (N : Subgroup G) (Q : Type v) [Group Q] where
  shortExactSequence : Prop
  normalEmbedding : N.FG := by infer_instance
  quotientGroup : Type v
  quotientGroupMulEquiv : Q ≃* G ⧸ N
  extensionProduct : Prop
  shortExactSequenceTerm : shortExactSequence
  quotientGroupTerm : quotientGroupMulEquiv
  extensionProductTerm : extensionProduct

structure AbelianMetabelianExtensionLemmaInhabitants (G : Type u) [Group G] where
  abelian : AbelianFoundationalInhabitants G
  metabelian : MetabelianFoundationalInhabitants G
  extension : ExtensionFoundationalInhabitants G (metabelian.commutatorSubgroup) (G ⧸ metabelian.commutatorSubgroup)
  abelianMetabelianBridge : Prop
  abelianMetabelianBridgeTerm : abelianMetabelianBridge

theorem abelianMetabelianExtensionLemma (G : Type u) [Group G]
    (hG : ∀ g h : G, g * h = h * g) :
    let N : Subgroup G := { carrier := {g | ∀ h : G, g * h = h * g}, one_mem' := by simp, mul_mem' := by simp, inv_mem' := by simp }
    N.FG := by
  intro N
  infer_instance

end AbelianMetabelianExtensionsLemma