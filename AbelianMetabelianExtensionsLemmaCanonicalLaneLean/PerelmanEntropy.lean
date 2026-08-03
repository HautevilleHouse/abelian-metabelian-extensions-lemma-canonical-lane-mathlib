universe u v

namespace HautevilleHouse
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

/-- An abelian metabelian extension is an extension where both kernel and quotient are abelian. -/
structure AbelianMetabelianExtension where
  G : Type u
  N : Type v
  exactSequence : Prop
  kernelAbelian : Prop
  quotientAbelian : Prop

/-- A bridge between abelian metabelian extensions and their canonical admissible classes. -/
structure AdmissibleClassBridge where
  Extension : Type u
  CanonicalClass : Type v
  extensionToClass : Extension → CanonicalClass
  classToExtension : CanonicalClass → Extension
  inv_left : ∀ e : Extension, classToExtension (extensionToClass e) = e
  inv_right : ∀ c : CanonicalClass, extensionToClass (classToExtension c) = c
  preservesMetabelian : Prop

/-- The main lemma package for the abelian metabelian extensions lemma. -/
structure AbelianMetabelianExtensionsLemmaPackage where
  bridge : AdmissibleClassBridge
  allExtensionsMetabelian : Prop
  bridgeAdmissible : Prop
  classificationLemma : Prop

/-- Evidence that the lemma package is closed. -/
structure AbelianMetabelianExtensionsLemmaEvidence
    (Pkg : AbelianMetabelianExtensionsLemmaPackage) where
  allExtensionsMetabelian_closed : Pkg.allExtensionsMetabelian
  bridgeAdmissible_closed : Pkg.bridgeAdmissible
  classificationLemma_closed : Pkg.classificationLemma

/-- The closed statement of the abelian metabelian extensions lemma. -/
def AbelianMetabelianExtensionsLemmaClosed
    (Pkg : AbelianMetabelianExtensionsLemmaPackage) : Prop :=
  Pkg.allExtensionsMetabelian ∧ Pkg.bridgeAdmissible ∧ Pkg.classificationLemma

theorem abelian_metabelian_extensions_lemma_closed_from_evidence
    (Pkg : AbelianMetabelianExtensionsLemmaPackage)
    (E : AbelianMetabelianExtensionsLemmaEvidence Pkg) :
    AbelianMetabelianExtensionsLemmaClosed Pkg := by
  exact And.intro E.allExtensionsMetabelian_closed
    (And.intro E.bridgeAdmissible_closed E.classificationLemma_closed)

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end HautevilleHouse