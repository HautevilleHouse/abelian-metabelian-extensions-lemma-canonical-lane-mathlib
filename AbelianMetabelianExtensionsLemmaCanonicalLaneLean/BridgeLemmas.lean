import AbelianMetabelianExtensionsLemmaCanonicalLaneLean.AdmissibleClass

namespace HautevilleHouse
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

def bridgeClosed (A : AdmissibleClass) : Prop :=
  AbelianMetabelianWitnessClosed A.object

theorem bridge_from_admissible_class (A : AdmissibleClass) :
    bridgeClosed A := by
  exact A.object.conclusion

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end HautevilleHouse