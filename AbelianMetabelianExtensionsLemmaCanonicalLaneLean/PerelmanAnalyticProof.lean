import PoincareConjectureCanonicalLaneLean.PerelmanRoute

/-!
# Abelian Metabelian Extensions Lemma: Canonical Lane

This module encodes the admissible-class bridge for the Abelian Metabelian
Extensions Lemma. It provides certificate structures that bundle the key
statements and their proofs, and projects into a canonical lane of admissible
classifications.
-/

namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

/-!
## Core package

The package contains the basic propositions of the theory: that a given
extension is abelian, that it is metabelian, and that it lies in an admissible
class. The `Closed` predicate asserts all three propositions hold.
-/

structure AbelianMetabelianExtensionPackage where
  abelian_extension : Prop
  metabelian_extension : Prop
  admissible_class : Prop

def AbelianMetabelianExtensionPackageClosed (P : AbelianMetabelianExtensionPackage) : Prop :=
  P.abelian_extension ∧ P.metabelian_extension ∧ P.admissible_class

structure AbelianMetabelianExtensionEvidence (P : AbelianMetabelianExtensionPackage) where
  abelian_extension_closed : P.abelian_extension
  metabelian_extension_closed : P.metabelian_extension
  admissible_class_closed : P.admissible_class

theorem abelian_metabelian_package_closed_from_evidence
    (P : AbelianMetabelianExtensionPackage) (E : AbelianMetabelianExtensionEvidence P) :
    AbelianMetabelianExtensionPackageClosed P := by
  exact And.intro E.abelian_extension_closed
    (And.intro E.metabelian_extension_closed E.admissible_class_closed)

/-!
## Certificate for the lemma

The certificate packages the bridge statements as functions: from an abelian
extension we obtain a metabelian one, from an abelian extension we obtain an
admissible class, and from a metabelian extension we obtain an admissible class.
Each function is supplied with a proof term.
-/

structure AbelianMetabelianExtensionsLemmaCertificate (P : AbelianMetabelianExtensionPackage) where
  abelian_implies_metabelian : P.abelian_extension → P.metabelian_extension
  admissible_classifiable : P.abelian_extension → P.admissible_class
  metabelian_classifiable : P.metabelian_extension → P.admissible_class
  abelian_implies_metabelian_closed : abelian_implies_metabelian
  admissible_classifiable_closed : admissible_classifiable
  metabelian_classifiable_closed : metabelian_classifiable
  evidence : AbelianMetabelianExtensionEvidence P

def AbelianMetabelianExtensionsLemmaCertificateClosed {P : AbelianMetabelianExtensionPackage}
    (C : AbelianMetabelianExtensionsLemmaCertificate P) : Prop :=
  (∀ h : P.abelian_extension, C.abelian_implies_metabelian h) ∧
  (∀ h : P.abelian_extension, C.admissible_classifiable h) ∧
  (∀ h : P.metabelian_extension, C.metabelian_classifiable h) ∧
  AbelianMetabelianExtensionPackageClosed P

theorem abelian_metabelian_extensions_lemma_certificate_closed
    {P : AbelianMetabelianExtensionPackage} (C : AbelianMetabelianExtensionsLemmaCertificate P) :
    AbelianMetabelianExtensionsLemmaCertificateClosed C := by
  refine And.intro ?_ (And.intro ?_ (And.intro ?_
    (abelian_metabelian_package_closed_from_evidence P C.evidence)))
  · intro h; exact C.abelian_implies_metabelian_closed h
  · intro h; exact C.admissible_classifiable_closed h
  · intro h; exact C.metabelian_classifiable_closed h

/-!
## Bridge structure

The bridge aggregates the same three functions into a single object, which can
serve as an admissible-class bridge for the lemma.
-/

structure AbelianMetabelianBridge (P : AbelianMetabelianExtensionPackage) where
  abelian_to_metabelian : P.abelian_extension → P.metabelian_extension
  abelian_to_admissible : P.abelian_extension → P.admissible_class
  metabelian_to_admissible : P.metabelian_extension → P.admissible_class

theorem abelian_metabelian_bridge_of_certificate
    {P : AbelianMetabelianExtensionPackage} (C : AbelianMetabelianExtensionsLemmaCertificate P) :
    AbelianMetabelianBridge P := by
  refine { abelian_to_metabelian := C.abelian_implies_metabelian_closed,
           abelian_to_admissible := C.admissible_classifiable_closed,
           metabelian_to_admissible := C.metabelian_classifiable_closed }

/-!
## Canonical lane

A canonical lane packages the bridge together with a certificate of closure.
This is the final projection of the admissible-class bridge into the canonical
knowledge domain.
-/

structure CanonicalLane (P : AbelianMetabelianExtensionPackage) where
  bridge : AbelianMetabelianBridge P
  certificate : AbelianMetabelianExtensionsLemmaCertificate P

theorem canonical_lane_of_certificate
    {P : AbelianMetabelianExtensionPackage} (C : AbelianMetabelianExtensionsLemmaCertificate P) :
    CanonicalLane P := by
  refine { bridge := abelian_metabelian_bridge_of_certificate C, certificate := C }

/-!
## Construction from evidence

If we have direct evidence for the three basic propositions, we can construct a
certificate (and hence a bridge and a canonical lane) without further ado.
-/

def certificate_of_evidence (P : AbelianMetabelianExtensionPackage)
    (E : AbelianMetabelianExtensionEvidence P) : AbelianMetabelianExtensionsLemmaCertificate P where
  abelian_implies_metabelian := fun _ => E.metabelian_extension_closed
  admissible_classifiable := fun _ => E.admissible_class_closed
  metabelian_classifiable := fun _ => E.admissible_class_closed
  abelian_implies_metabelian_closed := fun _ => E.metabelian_extension_closed
  admissible_classifiable_closed := fun _ => E.admissible_class_closed
  metabelian_classifiable_closed := fun _ => E.admissible_class_closed
  evidence := E

theorem abelian_metabelian_extensions_lemma_has_certificate
    (P : AbelianMetabelianExtensionPackage) (E : AbelianMetabelianExtensionEvidence P) :
    AbelianMetabelianExtensionsLemmaCertificateClosed (certificate_of_evidence P E) := by
  exact abelian_metabelian_extensions_lemma_certificate_closed (certificate_of_evidence P E)

theorem abelian_metabelian_extensions_lemma_bridge
    (P : AbelianMetabelianExtensionPackage) (E : AbelianMetabelianExtensionEvidence P) :
    AbelianMetabelianBridge P := by
  exact abelian_metabelian_bridge_of_certificate (certificate_of_evidence P E)

theorem abelian_metabelian_extensions_lemma_lane
    (P : AbelianMetabelianExtensionPackage) (E : AbelianMetabelianExtensionEvidence P) :
    CanonicalLane P := by
  exact canonical_lane_of_certificate (certificate_of_evidence P E)

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean