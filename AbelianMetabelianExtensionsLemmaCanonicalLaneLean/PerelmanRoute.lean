import Mathlib

/-!
# Perelman Route Layer (Abelian Metabelian Extensions)

This module records the theorem-route obligations that connect the Abelian
Metabelian Extensions Lemma Canonical Lane to the admissible-class bridge:
abelian kernel, abelian quotient, metabelian descent, admissible class, and
the canonical lane closure condition.
-/

namespace HautevilleHouse
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

/-!
Obligations for the abelian metabelian extension lemma.
-/
structure AbelianMetabelianExtensionObligations where
  extensionNonempty : Prop
  kernelAbelian : Prop
  quotientAbelian : Prop
  metabelian : Prop
  admissibleClass : Prop

/-!
Closed evidence for each obligation.
-/
structure AbelianMetabelianExtensionEvidence (O : AbelianMetabelianExtensionObligations) where
  extensionNonempty_evidence : O.extensionNonempty
  kernelAbelian_evidence : O.kernelAbelian
  quotientAbelian_evidence : O.quotientAbelian
  metabelian_evidence : O.metabelian
  admissibleClass_evidence : O.admissibleClass

/-!
The abelian metabelian extension route is closed when each obligation has evidence.
-/
def AbelianMetabelianExtensionClosed (O : AbelianMetabelianExtensionObligations) : Prop :=
  O.extensionNonempty ∧
  O.kernelAbelian ∧
  O.quotientAbelian ∧
  O.metabelian ∧
  O.admissibleClass

/-!
The admissible-class bridge for the canonical lane.
-/
structure AdmissibleClassBridge (O : AbelianMetabelianExtensionObligations) where
  admissibleClass_implies_metabelian : O.admissibleClass → O.metabelian
  metabelian_implies_admissibleClass : O.metabelian → O.admissibleClass

/-!
Foundation structure: a collection of abelian-metabelian extension data
and their evidence, from which obligations can be projected.
-/
structure AbelianMetabelianExtensionFoundation where
  extensionNonempty : Prop
  kernelAbelian : Prop
  quotientAbelian : Prop
  metabelian : Prop
  admissibleClass : Prop
  extensionNonempty_evidence : extensionNonempty
  kernelAbelian_evidence : kernelAbelian
  quotientAbelian_evidence : quotientAbelian
  metabelian_evidence : metabelian
  admissibleClass_evidence : admissibleClass

/-!
Projection from the foundation to the obligation set.
-/
def AbelianMetabelianExtensionFoundation.toObligations
    (F : AbelianMetabelianExtensionFoundation) : AbelianMetabelianExtensionObligations :=
  { extensionNonempty := F.extensionNonempty
    kernelAbelian := F.kernelAbelian
    quotientAbelian := F.quotientAbelian
    metabelian := F.metabelian
    admissibleClass := F.admissibleClass
  }

/-!
Closed foundation evidence produces the obligation evidence used by this module.
-/
def AbelianMetabelianExtensionFoundation.toEvidence
    (F : AbelianMetabelianExtensionFoundation) :
    AbelianMetabelianExtensionEvidence F.toObligations :=
  { extensionNonempty_evidence := F.extensionNonempty_evidence
    kernelAbelian_evidence := F.kernelAbelian_evidence
    quotientAbelian_evidence := F.quotientAbelian_evidence
    metabelian_evidence := F.metabelian_evidence
    admissibleClass_evidence := F.admissibleClass_evidence
  }

/-!
Closed evidence gives the closed abelian metabelian extension proposition.
-/
theorem abelian_metabelian_extension_closed_from_evidence
    (O : AbelianMetabelianExtensionObligations)
    (E : AbelianMetabelianExtensionEvidence O) :
    AbelianMetabelianExtensionClosed O := by
  exact And.intro E.extensionNonempty_evidence
    (And.intro E.kernelAbelian_evidence
      (And.intro E.quotientAbelian_evidence
        (And.intro E.metabelian_evidence E.admissibleClass_evidence)))

/-!
A closed foundation closes the obligation set.
-/
theorem abelian_metabelian_extension_closed_from_foundation
    (F : AbelianMetabelianExtensionFoundation) :
    AbelianMetabelianExtensionClosed F.toObligations := by
  exact abelian_metabelian_extension_closed_from_evidence F.toObligations F.toEvidence

/-!
The Abelian Metabelian Extensions Lemma as a global statement.
-/
def AbelianMetabelianExtensionsLemma : Prop :=
  ∀ (O : AbelianMetabelianExtensionObligations),
    O.extensionNonempty → O.kernelAbelian → O.quotientAbelian →
      O.metabelian ∧ O.admissibleClass

/-!
The canonical lane is closed whenever the lemma provides both the metabelian
condition and the admissible class.
-/
theorem canonical_lane_closed_of_lemma
    (O : AbelianMetabelianExtensionObligations)
    (h : AbelianMetabelianExtensionsLemma)
    (hne : O.extensionNonempty) (hka : O.kernelAbelian) (hqa : O.quotientAbelian) :
    AbelianMetabelianExtensionClosed O := by
  have hma := (h O hne hka hqa).1
  have hac := (h O hne hka hqa).2
  exact And.intro hne (And.intro hka (And.intro hqa (And.intro hma hac)))

/-!
A bridge from the admissible class to the metabelian property and back.
-/
theorem admissible_class_bridge_iff
    (O : AbelianMetabelianExtensionObligations)
    (B : AdmissibleClassBridge O) :
    O.admissibleClass ↔ O.metabelian := by
  constructor
  · exact B.admissibleClass_implies_metabelian
  · exact B.metabelian_implies_admissibleClass

/-!
The full admissible-class bridge remains the explicit formalization payload.
-/
def abelianMetabelianFormalizationPayload : String :=
  "Abelian metabelian extensions, admissible class, canonical lane closure, kernel and quotient abelianity, metabelian descent."

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end HautevilleHouse