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
  have hN'_normal : N'.Normal := by
    -- The image of N is exactly the kernel of q, so it is normal.
    sorry
  have hN'_abelian : IsAbelianGroup N' := by
    -- The image of an abelian group under a homomorphism is abelian.
    sorry
  have hquotient_abelian : IsAbelianGroup (E.G ⧸ N') := by
    -- Since q is surjective and its kernel is N', the quotient is isomorphic to Q, which is abelian.
    sorry
  exact ⟨N', hN'_normal, hN'_abelian, hquotient_abelian⟩

/-- The key lemma: every abelian-by-abelian group is metabelian. -/
theorem abelianByAbelian_isMetabelian
    {G : Type u} [Group G] (h : AbelianByAbelianExtension G) :
    IsMetabelian G := by
  -- The commutator subgroup is contained in h.N, because the quotient is abelian.
  -- Since h.N is abelian, any subgroup of it is abelian.
  sorry

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
    -- Given a metabelian group, its derived subgroup is an abelian normal subgroup with abelian quotient.
    sorry

end AbelianMetabelian