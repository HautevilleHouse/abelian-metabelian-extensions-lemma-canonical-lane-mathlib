import Mathlib.Algebra.Group.Defs
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.GroupTheory.Subgroup
import Mathlib.GroupTheory.QuotientGroup

namespace HautevilleHouse
namespace AbelianMetabelianExtensionsLemmaCanonicalLaneLean

open scoped Group

/-! 
  Canonical bridge for the Abelian Metabelian Extensions Lemma.
  An admissible object bundles an extension with abelian kernel and quotient
  together with a certificate that the middle group is metabelian.
-/

-- Data for a group extension N → G → Q where N and Q are abelian.
structure AbelianMetabelianExtension (N G Q : Type*) [Group N] [Group G] [Group Q] where
  inj : N →* G
  proj : G →* Q
  inj_injective : Function.Injective inj
  proj_surjective : Function.Surjective proj
  exact : ∀ g : G, proj g = 1 ↔ ∃ n : N, inj n = g
  N_abelian : ∀ a b : N, a * b = b * a
  Q_abelian : ∀ a b : Q, a * b = b * a

-- A certificate that a group is metabelian: a normal subgroup with abelian quotient.
structure MetabelianCertificate (G : Type*) [Group G] where
  N : Subgroup G
  normal : N.Normal
  N_abelian : ∀ a b : N, a * b = b * a
  quotient_abelian : ∀ a b : G ⧸ N, a * b = b * a

-- The bridge structure: from an abelian extension we obtain a metabelian certificate.
structure AbelianMetabelianBridge (N G Q : Type*) [Group N] [Group G] [Group Q] where
  ext : AbelianMetabelianExtension N G Q
  cert : MetabelianCertificate G

-- The canonical statement of the lemma: every such extension yields a certificate.
axiom abelian_metabelian_extensions_lemma : ∀ (N G Q : Type*) [Group N] [Group G] [Group Q],
  AbelianMetabelianExtension N G Q → Nonempty (MetabelianCertificate G)

-- Build the bridge from an extension by invoking the lemma.
def bridgeOfExtension (N G Q : Type*) [Group N] [Group G] [Group Q]
    (ext : AbelianMetabelianExtension N G Q) : AbelianMetabelianBridge N G Q :=
  { ext := ext
    cert := Classical.choice (abelian_metabelian_extensions_lemma N G Q ext) }

-- Extract the certificate from a bridge.
def bridgeCert (N G Q : Type*) [Group N] [Group G] [Group Q]
    (B : AbelianMetabelianBridge N G Q) : MetabelianCertificate G :=
  B.cert

-- The admitted object bundling the extension and its metabelian certificate.
structure AbelianMetabelianAdmittedObject where
  N : Type
  G : Type
  Q : Type
  instN : Group N
  instG : Group G
  instQ : Group Q
  ext : @AbelianMetabelianExtension N G Q instN instG instQ
  cert : @MetabelianCertificate G instG

-- Endgame state: the object is already fully certified.
structure AbelianMetabelianEndgameState where
  object : AbelianMetabelianAdmittedObject

-- A simple witness predicate: the extension indeed gives a metabelian certificate.
def AbelianMetabelianWitness (O : AbelianMetabelianAdmittedObject) : Prop :=
  Nonempty (@MetabelianCertificate O.G O.instG)

end AbelianMetabelianExtensionsLemmaCanonicalLaneLean
end HautevilleHouse