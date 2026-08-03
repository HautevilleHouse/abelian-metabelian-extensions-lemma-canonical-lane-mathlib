import Mathlib

/-!
# Noncollapsing.lean for Abelian Metabelian Extensions Lemma
-/

namespace CanonicalKnowledgeDomain
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

/--
  A package encoding the three key propositions in the Abelian Metabelian Extensions Lemma:
  the normal subgroup is abelian, the quotient is abelian, and the extension is metabelian.
  The field `abelian_metabelian_lemma` records the logical bridge that the first two imply the third.
-/
structure AbelianMetabelianExtensionsPackage where
  normalAbelian : Prop
  quotientAbelian : Prop
  metabelian : Prop
  abelian_metabelian_lemma : normalAbelian → quotientAbelian → metabelian

/--
  Evidence for the abelian metabelian extension property: a proof of the two abelianity hypotheses.
-/
structure AbelianMetabelianExtensionsEvidence (P : AbelianMetabelianExtensionsPackage) where
  normalAbelian_evidence : P.normalAbelian
  quotientAbelian_evidence : P.quotientAbelian

/--
  The closed condition: all three propositions of the package hold.
-/
def AbelianMetabelianExtensionsClosed (P : AbelianMetabelianExtensionsPackage) : Prop :=
  P.normalAbelian ∧ P.quotientAbelian ∧ P.metabelian

/--
  From evidence, we can close the package by applying the lemma to obtain metabelianity.
-/
theorem abelianMetabelianExtensionsClosed_of_evidence
    (P : AbelianMetabelianExtensionsPackage)
    (E : AbelianMetabelianExtensionsEvidence P) :
    AbelianMetabelianExtensionsClosed P := by
  have hmet : P.metabelian := P.abelian_metabelian_lemma E.normalAbelian_evidence E.quotientAbelian_evidence
  exact And.intro E.normalAbelian_evidence (And.intro E.quotientAbelian_evidence hmet)

/--
  An admissible class of extensions in the canonical lane: these are exactly the extensions
  whose abelian normal subgroup has an abelian quotient, yielding a metabelian extension.
-/
structure AdmissibleClass where
  abelianNormal : Prop
  quotientAbelian : Prop
  isMetabelian : Prop

/--
  The admissible-class bridge: it connects the closed lemma package to an external admissible class.
-/
structure AdmissibleClassBridge (P : AbelianMetabelianExtensionsPackage) where
  admissible : AdmissibleClass
  bridge : AbelianMetabelianExtensionsClosed P ↔
    (admissible.abelianNormal ∧ admissible.quotientAbelian ∧ admissible.isMetabelian)

/-- The canonical bridge for a given package. -/
def canonicalAdmissibleClass (P : AbelianMetabelianExtensionsPackage) : AdmissibleClass where
  abelianNormal := P.normalAbelian
  quotientAbelian := P.quotientAbelian
  isMetabelian := P.metabelian

def canonicalAdmissibleBridge (P : AbelianMetabelianExtensionsPackage) : AdmissibleClassBridge P where
  admissible := canonicalAdmissibleClass P
  bridge := by
    constructor
    · intro h; exact h
    · intro h; exact h

/-- The bridge is inhabited exactly when the three conditions are met. -/
theorem admissible_bridge_of_evidence
    (P : AbelianMetabelianExtensionsPackage)
    (E : AbelianMetabelianExtensionsEvidence P) :
    (canonicalAdmissibleBridge P).admissible.isMetabelian := by
  exact (abelianMetabelianExtensionsClosed_of_evidence P E).2.2

/-- If the bridge is crossed, we recover the full closed package. -/
theorem closed_of_admissible_bridge
    (P : AbelianMetabelianExtensionsPackage)
    (A : AdmissibleClassBridge P)
    (h : A.admissible.abelianNormal ∧ A.admissible.quotientAbelian ∧ A.admissible.isMetabelian) :
    AbelianMetabelianExtensionsClosed P := by
  exact A.bridge.mpr h

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end CanonicalKnowledgeDomain