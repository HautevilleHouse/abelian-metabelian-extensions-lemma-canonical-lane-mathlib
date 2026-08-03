import AbelianMetabelianExtensionsLemmaCanonicalLaneLean.FoundationalInhabitants

/-!
# Abelian Metabelian Extensions Lemma: Deep Analytic Construction

This module refines the foundational inhabitants for the Abelian Metabelian
Extensions Lemma into a deeper algebraic construction interface. The
construction names the short exact sequence, kernel abelianity, quotient
metabelianity, derived subgroup properties, and extension splitting data
that feed the already checked canonical route.

The module is intentionally term-level: each algebraic construction supplies
Lean inhabitants for its named algebraic components and maps them into the
foundational theorem inhabitants used by the route closure.
-/

namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

structure AbelianMetabelianExtensionConstruction where
  shortExactSequence : Prop
  kernelIsNormal : Prop
  kernelIsAbelian : Prop
  quotientIsAbelian : Prop
  quotientIsMetabelian : Prop
  derivedSubgroupIsAbelian : Prop
  derivedSubgroupIsNormal : Prop
  commutatorSubgroupInKernel : Prop
  quotientResiduallyFinite : Prop
  extensionSplits : Prop
  semidirectDecomposition : Prop

  -- Derived statements that bridge to the foundational layer
  abelianKernel : Prop
  metabelianQuotient : Prop
  extensionMetabelian : Prop
  extensionSolvable : Prop
  derivedLengthAtMostTwo : Prop
  extensionResiduallyFinite : Prop

  -- Proofs of the raw structural facts
  shortExactSequenceTerm : shortExactSequence
  kernelIsNormalTerm : kernelIsNormal
  kernelIsAbelianTerm : kernelIsAbelian
  quotientIsAbelianTerm : quotientIsAbelian
  quotientIsMetabelianTerm : quotientIsMetabelian
  derivedSubgroupIsAbelianTerm : derivedSubgroupIsAbelian
  derivedSubgroupIsNormalTerm : derivedSubgroupIsNormal
  commutatorSubgroupInKernelTerm : commutatorSubgroupInKernel
  quotientResiduallyFiniteTerm : quotientResiduallyFinite
  extensionSplitsTerm : extensionSplits
  semidirectDecompositionTerm : semidirectDecomposition

  -- Derivation functions from raw structural facts to the bridge statements
  abelianKernelFromConstruction :
    kernelIsAbelian -> abelianKernel
  metabelianQuotientFromConstruction :
    quotientIsMetabelian -> metabelianQuotient
  extensionMetabelianFromConstruction :
    kernelIsAbelian -> quotientIsAbelian -> commutatorSubgroupInKernel ->
      extensionMetabelian
  extensionSolvableFromConstruction :
    kernelIsAbelian -> quotientIsAbelian -> commutatorSubgroupInKernel ->
      extensionSolvable
  derivedLengthAtMostTwoFromConstruction :
    kernelIsAbelian -> quotientIsAbelian -> commutatorSubgroupInKernel ->
      derivedLengthAtMostTwo
  extensionResiduallyFiniteFromConstruction :
    kernelIsAbelian -> quotientResiduallyFinite -> extensionResiduallyFinite
  semidirectDecompositionFromConstruction :
    extensionSplits -> kernelIsNormal -> semidirectDecomposition

def AbelianMetabelianExtensionConstruction.toFoundational
    (C : AbelianMetabelianExtensionConstruction) :
    AbelianMetabelianExtensionsLemmaFoundationalInhabitants := {
  abelianKernel := C.abelianKernel
  metabelianQuotient := C.metabelianQuotient
  extensionMetabelian := C.extensionMetabelian
  extensionSolvable := C.extensionSolvable
  derivedLengthAtMostTwo := C.derivedLengthAtMostTwo
  extensionResiduallyFinite := C.extensionResiduallyFinite
  abelianKernelTerm := C.abelianKernelFromConstruction C.kernelIsAbelianTerm
  metabelianQuotientTerm := C.metabelianQuotientFromConstruction C.quotientIsMetabelianTerm
  extensionMetabelianTerm :=
    C.extensionMetabelianFromConstruction
      C.kernelIsAbelianTerm
      C.quotientIsAbelianTerm
      C.commutatorSubgroupInKernelTerm
  extensionSolvableTerm :=
    C.extensionSolvableFromConstruction
      C.kernelIsAbelianTerm
      C.quotientIsAbelianTerm
      C.commutatorSubgroupInKernelTerm
  derivedLengthAtMostTwoTerm :=
    C.derivedLengthAtMostTwoFromConstruction
      C.kernelIsAbelianTerm
      C.quotientIsAbelianTerm
      C.commutatorSubgroupInKernelTerm
  extensionResiduallyFiniteTerm :=
    C.extensionResiduallyFiniteFromConstruction
      C.kernelIsAbelianTerm
      C.quotientResiduallyFiniteTerm
}

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean