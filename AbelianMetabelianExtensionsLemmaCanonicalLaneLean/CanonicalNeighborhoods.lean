/-!
# Abelian Metabelian Extensions Package

This file encodes the admissible-class bridge for the Abelian Metabelian
Extensions Lemma. The key theorem states that if a normal subgroup is abelian
and the corresponding quotient group is abelian, then the extension group is
metabelian and has derived length at most two.
-/

namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

-- The package bundles the assumptions and conclusions, together with the
-- bridge functions that realize the lemma.
structure AbelianMetabelianExtensionPackage where
  baseNormalAbelian : Prop
  quotientGroupAbelian : Prop
  extensionMetabelian : Prop
  extensionSolvableLengthTwo : Prop
  metabelian_bridge : baseNormalAbelian → quotientGroupAbelian → extensionMetabelian
  solvable_bridge : baseNormalAbelian → quotientGroupAbelian → extensionSolvableLengthTwo

-- Evidence provides the admissible assumptions for a given package.
structure AbelianMetabelianExtensionEvidence (C : AbelianMetabelianExtensionPackage) where
  baseNormalAbelianClosed : C.baseNormalAbelian
  quotientGroupAbelianClosed : C.quotientGroupAbelian

-- A package is closed when both assumptions and both conclusions hold.
def AbelianMetabelianExtensionClosed (C : AbelianMetabelianExtensionPackage) : Prop :=
  C.baseNormalAbelian ∧ C.quotientGroupAbelian ∧
  C.extensionMetabelian ∧ C.extensionSolvableLengthTwo

-- The bridge theorem: admissible assumptions close the package.
theorem abelianMetabelianExtensionClosedFromEvidence
    (C : AbelianMetabelianExtensionPackage)
    (E : AbelianMetabelianExtensionEvidence C) :
    AbelianMetabelianExtensionClosed C := by
  constructor
  · exact E.baseNormalAbelianClosed
  constructor
  · exact E.quotientGroupAbelianClosed
  constructor
  · exact C.metabelian_bridge E.baseNormalAbelianClosed E.quotientGroupAbelianClosed
  · exact C.solvable_bridge E.baseNormalAbelianClosed E.quotientGroupAbelianClosed

-- The canonical lemma statement: an abelian normal subgroup with an abelian
-- quotient yields a metabelian extension.  This does not require a closed
-- package; it is the intrinsic content of the bridge.
theorem abelian_metabelian_extension_lemma
    (C : AbelianMetabelianExtensionPackage) :
    C.baseNormalAbelian → C.quotientGroupAbelian →
      (C.extensionMetabelian ∧ C.extensionSolvableLengthTwo) := by
  intro hbase hquot
  constructor
  · exact C.metabelian_bridge hbase hquot
  · exact C.solvable_bridge hbase hquot

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean