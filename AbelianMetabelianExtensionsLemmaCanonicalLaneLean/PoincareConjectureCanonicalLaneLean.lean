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
import Mathlib.GroupTheory.QuotientGroup
import Mathlib.GroupTheory.Commutator

universe u v w

namespace AbelianMetabelian

/-- A group is abelian if all elements commute. -/
def IsAbelianGroup (G : Type u) [Group G] : Prop :=
  ∀ a b : G, a * b = b * a

/-- A group is metabelian if its derived subgroup is abelian. -/
def IsMetabelian (G : Type u) [Group G] : Prop :=
  IsAbelianGroup (Subgroup.commutator ⊤ ⊤ : Subgroup G)

/-- An extensional witness that a group G is an abelian-by-abelian extension:
    an abelian normal subgroup N such that G/N is abelian. -/
structure AbelianByAbelianExtension (G : Type u) [Group G] : Prop where
  N : Subgroup G
  normal : N.Normal
  abelian_N : IsAbelianGroup N
  abelian_quotient : IsAbelianGroup (G ⧸ N)

/-- An explicit short exact sequence 1 → N → G → Q → 1 with N and Q abelian. -/
structure AbelianMetabelianExtension where
  G : Type u
  N : Type v
  Q : Type w
  [groupG : Group G]
  [groupN : Group N]
  [groupQ : Group Q]
  [abelianN : IsAbelianGroup N]
  [abelianQ : IsAbelianGroup Q]
  n : N →* G
  q : G →* Q
  n_injective : Function.Injective n
  q_surjective : Function.Surjective q
  exact : ∀ x : G, q x = 1 ↔ ∃ y : N, n y = x

attribute [instance] AbelianMetabelianExtension.groupG AbelianMetabelianExtension.groupN AbelianMetabelianExtension.groupQ

/-- The image of the injective map from N is an abelian normal subgroup with abelian quotient. -/
def abelianByAbelianExtensionOfExtension
    (E : AbelianMetabelianExtension.{u, v, w}) :
    AbelianByAbelianExtension E.G := by
  let N' : Subgroup E.G := (Subgroup.map E.n ⊤)
  have hN'_eq_ker : N' = E.q.ker := by
    apply Subgroup.ext
    intro x
    constructor
    · intro hx
      rw [Subgroup.mem_map] at hx
      rcases hx with ⟨y, hy, rfl⟩
      rw [Subgroup.mem_ker]
      exact (E.exact (E.n y)).2 ⟨y, rfl⟩
    · intro hx
      rw [Subgroup.mem_ker] at hx
      rw [Subgroup.mem_map]
      rcases (E.exact x).1 hx with ⟨y, hy⟩
      exact ⟨y, by simp, hy⟩
  have hN'_normal : N'.Normal := by
    rw [hN'_eq_ker]
    infer_instance
  have hN'_abelian : IsAbelianGroup N' := by
    intro a b
    apply Subtype.ext
    change (a : E.G) * (b : E.G) = (b : E.G) * (a : E.G)
    rcases (Subgroup.mem_map.mp a.2) with ⟨u, hu, rfl⟩
    rcases (Subgroup.mem_map.mp b.2) with ⟨v, hv, rfl⟩
    rw [← E.n.map_mul, ← E.n.map_mul, E.abelianN u v]
  letI : N'.Normal := hN'_normal
  have hquotient_abelian : IsAbelianGroup (E.G ⧸ N') := by
    intro a b
    refine Quotient.induction_on₂ a b ?_
    intro x y
    rw [← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul]
    rw [QuotientGroup.eq]
    rw [hN'_eq_ker, Subgroup.mem_ker]
    simp only [map_mul, map_inv]
    rw [E.abelianQ (E.q y) (E.q x)]
    simp
  exact ⟨N', hN'_normal, hN'_abelian, hquotient_abelian⟩

/-- The key lemma: every abelian-by-abelian group is metabelian. -/
theorem abelianByAbelian_isMetabelian
    {G : Type u} [Group G] (h : AbelianByAbelianExtension G) :
    IsMetabelian G := by
  let C : Subgroup G := Subgroup.commutator ⊤ ⊤
  letI : h.N.Normal := h.normal
  have hC_le_N : C ≤ h.N := by
    change Subgroup.commutator (⊤ : Subgroup G) (⊤ : Subgroup G) ≤ h.N
    rw [Subgroup.commutator_le]
    intro x hx y hy
    have hq : (QuotientGroup.mk (y * x) : G ⧸ h.N) = QuotientGroup.mk (x * y) := by
      simpa [QuotientGroup.mk_mul] using h.abelian_quotient (QuotientGroup.mk y) (QuotientGroup.mk x)
    have hmem : (y * x)⁻¹ * (x * y) ∈ h.N := by
      rwa [QuotientGroup.eq] at hq
    simpa [commutatorElement] using hmem
  have hC_abelian : IsAbelianGroup C := by
    intro a b
    apply Subtype.ext
    change (a : G) * (b : G) = (b : G) * (a : G)
    have ha : (a : G) ∈ h.N := hC_le_N a.2
    have hb : (b : G) ∈ h.N := hC_le_N b.2
    let aN : h.N := ⟨a.1, ha⟩
    let bN : h.N := ⟨b.1, hb⟩
    have hab : aN * bN = bN * aN := h.abelian_N aN bN
    simpa [aN, bN] using congrArg Subtype.val hab
  simpa [C, IsMetabelian] using hC_abelian

/-- Consequently, every explicit abelian metabelian extension is metabelian. -/
theorem abelianMetabelianExtension_isMetabelian
    (E : AbelianMetabelianExtension.{u, v, w}) :
    IsMetabelian E.G :=
  abelianByAbelian_isMetabelian (abelianByAbelianExtensionOfExtension E)

/-- Bridge statement: the class of abelian-by-abelian extensions coincides with metabelian groups. -/
theorem abelianByAbelian_iff_metabelian
    (G : Type u) [Group G] :
    Nonempty (AbelianByAbelianExtension G) ↔ IsMetabelian G := by
  constructor
  · intro h
    exact abelianByAbelian_isMetabelian h.some
  · intro hM
    let N : Subgroup G := Subgroup.commutator ⊤ ⊤
    have hN_normal : N.Normal := by
      exact Subgroup.commutator_normal ⊤ ⊤
    letI : N.Normal := hN_normal
    have hN_abelian : IsAbelianGroup N := by
      simpa [N, IsMetabelian] using hM
    have hN_quotient_abelian : IsAbelianGroup (G ⧸ N) := by
      intro a b
      refine Quotient.induction_on₂ a b ?_
      intro x y
      rw [← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul]
      rw [QuotientGroup.eq]
      have hcomm : ⁅y, x⁆ ∈ N := by
        have hle : Subgroup.commutator (⊤ : Subgroup G) (⊤ : Subgroup G) ≤ N := by rfl
        exact (Subgroup.commutator_le (⊤ : Subgroup G) (⊤ : Subgroup G) N).mp hle y (by simp) x (by simp)
      simpa [commutatorElement] using hcomm
    exact ⟨⟨N, hN_normal, hN_abelian, hN_quotient_abelian⟩⟩

end AbelianMetabelian