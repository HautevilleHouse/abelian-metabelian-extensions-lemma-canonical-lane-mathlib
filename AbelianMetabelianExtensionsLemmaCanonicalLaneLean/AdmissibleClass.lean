import Mathlib.Topology.Basic

/-!
# Admissible Class for Abelian Metabelian Extensions Lemma
-/

namespace HautevilleHouse
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

structure AbelianMetabelianAdmittedObject where
  extensionGroup : Type
  kernel : Type
  quotient : Type
  kernelAbelian : Prop
  quotientMetabelian : Prop
  shortExactSequence : Prop
  lemmaWitness : Prop
  conclusion : lemmaWitness

def AbelianMetabelianWitnessClosed (O : AbelianMetabelianAdmittedObject) : Prop :=
  O.lemmaWitness

structure AdmissibleClass where
  object : AbelianMetabelianAdmittedObject
  endpointSatisfied : Prop
  remainderRecorded : Prop
  gateWitness : endpointSatisfied ∨ remainderRecorded

def admittedClosure (A : AdmissibleClass) : Prop :=
  AbelianMetabelianWitnessClosed A.object ∧ (A.endpointSatisfied ∨ A.remainderRecorded)

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end HautevilleHouse