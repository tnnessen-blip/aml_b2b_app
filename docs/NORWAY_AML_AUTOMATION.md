# Norway AML Automation

Denne appen er p\u00e5 vei mot et norsk AML-arbeidsrom der brukeren fyller inn minst mulig manuelt, og der systemet bygger dokumentasjon fortl\u00f8pende.

## M\u00e5lbilde

1. Hent virksomhetsdata, roller og relevante registeropplysninger automatisk.
2. Oversett lovkrav til en konkret oppgaveliste i saken.
3. Lag revisjonsspor og dokumentpakke mens saksbehandler arbeider.
4. Stopp avvik og mangler f\u00f8r beslutning eller innsending.
5. La rapportering og oppf\u00f8lging leve i samme saksflyt.

## Verifiserte offentlige kilder

- Br\u00f8nn\u00f8ysundregistrene virksomhetsdata:
  [Data om virksomheter](https://www.brreg.no/bruke-data-fra-bronnoysundregistrene/datasett-og-api/data-om-virksomheter/)
- Br\u00f8nn\u00f8ysundregistrene reelle rettighetshavere:
  [Data om reelle rettighetshavere](https://www.brreg.no/bruke-data-fra-bronnoysundregistrene/datasett-og-api/data-om-reelle-rettighetshavere/)
- Br\u00f8nn\u00f8ysundregistrene om ulike kriterier i registeret og hvitvaskingsloven:
  [Reelle rettighetshavere](https://www.brreg.no/reelle-rettighetshavere/)
- Altinn datadeling:
  [Kom i gang med API](https://docs.data.altinn.no/api/)
- Altinn utviklerportal:
  [data.altinn.no](https://data.altinn.no/)
- Maskinporten:
  [Slik bruker du Maskinporten som API-konsument](https://docs.digdir.no/docs/Maskinporten/maskinporten_guide_apikonsument)
- Finanstilsynet om l\u00f8pende oppf\u00f8lging:
  [Veileder til hvitvaskingsloven](https://www.finanstilsynet.no/nyhetsarkiv/rundskriv/2022/veileder-til-hvitvaskingsloven/)
- \u00d8kokrim om MF-rapport:
  [Rapportere mistenkelige forhold (MF-rapport) til FIU](https://www.okokrim.no/rapporter-mistenkelige-forhold-til-fiu.562409.no.html)

## Produktkonsekvenser

- Brukeren skal ikke taste inn virksomhetsdata som kan hentes fra register.
- Kundesaken m\u00e5 vise registrert opplysning og intern AML-vurdering side om side.
- Regler skal foresl\u00e5 l\u00f8p og blokkere mangler, men ikke late som juridisk vurdering er helautomatisert.
- Rapportmodulen m\u00e5 gjenbruke det som allerede er samlet i saken.

## MVP-retning

- Opprett kundesak
- Hent virksomhetsdata fra Brreg
- Hent registrerte reelle rettighetshavere
- Sjekkliste for kundetiltak
- Enkel regelmotor
- Automatisk dokumentpakke / revisjonsspor
- Periodiske p\u00e5minnelser
- Rapportutkast for mistanke
