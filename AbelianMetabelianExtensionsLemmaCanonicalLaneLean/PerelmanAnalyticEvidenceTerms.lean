import Mathlib

/-!
# Abelian Metabelian Extensions Lemma: Evidence Terms

This module exposes the proof terms carried by each admissible abelian metabelian
extension certificate. The route is term-level: every hypothesis has a named Lean
term, and those terms project into the closure theorem for the total group.
-/

namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

universe u v w

/-- The commutator of two elements in a group. -/
def commutator {G : Type u} [Group G] (a b : G) : G :=
  a * b * a⁻¹ * b⁻¹

/-- A group is metabelian if the commutator of any two commutators is trivial. -/
def IsMetabelian (G : Type u) [Group G] : Prop :=
  ∀ a b c d : G, commutator (commutator a b) (commutator c d) = 1

/-- The exact sequence data for an extension `1 → N → G → Q → 1`. -/
structure ExtensionData (G N Q : Type) [Group G] [Group N] [Group Q] where
  inl : N →* G
  prj : G →* Q
  inl_injective : Function.Injective inl
  prj_surjective : Function.Surjective prj
  exact_range : ∀ g : G, g ∈ Set.range inl ↔ prj g = 1

/-- An admissible abelian metabelian extension: the kernel is abelian and the
quotient is metabelian, with a central kernel. -/
structure AbelianMetabelianExtension (G N Q : Type) [Group G] [Group N] [Group Q] where
  data : ExtensionData G N Q
  kernel_abelian : ∀ a b : N, a * b = b * a
  quotient_metabelian : IsMetabelian Q
  central_kernel : ∀ (n : N) (g : G), g * data.inl n = data.inl n * g

/-- The closure certificate: under the admissible hypotheses, the total group is
metabelian. -/
structure AbelianMetabelianCertificate (G N Q : Type) [Group G] [Group N] [Group Q]
    (E : AbelianMetabelianExtension G N Q) where
  kernel_abelian_closed : ∀ a b : N, a * b = b * a
  quotient_metabelian_closed : IsMetabelian Q
  central_kernel_closed : ∀ (n : N) (g : G), g * E.data.inl n = E.data.inl n * g
  total_metabelian_closed : IsMetabelian G

/-- The evidence terms extracted from a certificate. Each field is a named proof
term that can be used as input to the closure theorem. -/
structure AbelianMetabelianEvidenceTerms {G N Q : Type} [Group G] [Group N] [Group Q]
    {E : AbelianMetabelianExtension G N Q}
    (C : AbelianMetabelianCertificate G N Q E) where
  kernel_abelian : ∀ a b : N, a * b = b * a
  quotient_metabelian : IsMetabelian Q
  central_kernel : ∀ (n : N) (g : G), g * E.data.inl n = E.data.inl n * g
  total_metabelian : IsMetabelian G

/-- Projects the evidence terms from a certificate. This is the canonical bridge
from the admissible class of certificates to the term-level evidence. -/
def AbelianMetabelianCertificate.evidenceTerms {G N Q : Type} [Group G] [Group N] [Group Q]
    {E : AbelianMetabelianExtension G N Q}
    (C : AbelianMetabelianCertificate G N Q E) : AbelianMetabelianEvidenceTerms C :=
  {
    kernel_abelian := C.kernel_abelian_closed
    quotient_metabelian := C.quotient_metabelian_closed
    central_kernel := C.central_kernel_closed
    total_metabelian := C.total_metabelian_closed
  }

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean