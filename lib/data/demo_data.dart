import 'package:flutter/material.dart';

import '../models/aml_case.dart';
import '../models/automation_models.dart';
import '../models/audit_event.dart';
import '../models/transaction_event.dart';

const analysts = ['A. Solberg', 'M. Nilsen', 'S. Berg', 'K. Hansen'];

const initialCases = [
  AmlCase(
    id: 'AML-2048',
    customer: 'Nordfjord Import AS',
    segment: 'Import og engros',
    signal: 'Strukturering',
    summary: 'Strukturering via 18 innbetalinger',
    amount: 'kr 4,8 mill.',
    risk: 96,
    riskTone: 'critical',
    status: 'Ny',
    statusTone: 'critical',
    category: 'H\u00f8y',
    date: '26.04.2026',
    due: '29.04',
    owner: 'A. Solberg',
    country: 'Norge / Litauen',
    kycLevel: 'oppdatert',
    beneficialOwner: 'Verifisert',
    beneficialOwnerOk: true,
    note: 'Mange innbetalinger rett under terskel, rask videref\u00f8ring og ny utenlandsk motpart.',
  ),
  AmlCase(
    id: 'AML-2035',
    customer: 'Berg & Co Holding',
    segment: 'Holding og investering',
    signal: 'Sanksjonstreff',
    summary: 'Ny h\u00f8y-risiko motpart',
    amount: 'kr 980 000',
    risk: 88,
    riskTone: 'high',
    status: 'Vurderes',
    statusTone: 'review',
    category: 'Sanksjon',
    date: '27.04.2026',
    due: '28.04',
    owner: 'M. Nilsen',
    country: 'Norge / Kypros',
    kycLevel: 'oppdatert',
    beneficialOwner: 'Manuell kontroll',
    beneficialOwnerOk: false,
    note: 'Motpart matcher sanksjonsliste med h\u00f8y navnelikhet og overlappende adressehistorikk.',
  ),
  AmlCase(
    id: 'AML-2017',
    customer: 'Elva Trading Ltd',
    segment: 'Handel',
    signal: 'PEP-motpart',
    summary: 'Uvanlig handelsm\u00f8nster',
    amount: 'kr 1,3 mill.',
    risk: 79,
    riskTone: 'watch',
    status: 'Dokument',
    statusTone: 'watch',
    category: 'PEP',
    date: '25.04.2026',
    due: '30.04',
    owner: 'S. Berg',
    country: 'Storbritannia / Norge',
    kycLevel: 'venter dok.',
    beneficialOwner: 'Ikke komplett',
    beneficialOwnerOk: false,
    note: 'Ny PEP-n\u00e6r motpart og endret transaksjonsform\u00e5l fra tjenestekj\u00f8p til varehandel.',
  ),
  AmlCase(
    id: 'AML-1988',
    customer: 'Sj\u00f8lyst Konsulent',
    segment: 'Konsulent',
    signal: 'Kontantinnskudd',
    summary: 'Kontantinnskudd over forventet profil',
    amount: 'kr 640 000',
    risk: 84,
    riskTone: 'high',
    status: 'Ny',
    statusTone: 'critical',
    category: 'H\u00f8y',
    date: '24.04.2026',
    due: '29.04',
    owner: 'K. Hansen',
    country: 'Norge',
    kycLevel: 'oppdatert',
    beneficialOwner: 'Verifisert',
    beneficialOwnerOk: true,
    note: 'Kontantprofil avviker fra historisk aktivitet og er ikke forklart av oppdatert kundeinformasjon.',
  ),
  AmlCase(
    id: 'AML-1944',
    customer: 'M\u00f8llebyen Eiendom',
    segment: 'Eiendom',
    signal: 'Ukjent reell eier',
    summary: 'Eierskap krever oppdatert dokumentasjon',
    amount: 'kr 2,1 mill.',
    risk: 67,
    riskTone: 'medium',
    status: 'Lavere risiko',
    statusTone: 'closed',
    category: 'PEP',
    date: '21.04.2026',
    due: '01.05',
    owner: 'A. Solberg',
    country: 'Norge',
    kycLevel: 'oppdatert',
    beneficialOwner: 'Verifisert',
    beneficialOwnerOk: true,
    note: 'Dokumentasjon mottatt og reell eier er verifisert. Fortsetter med normal overv\u00e5king.',
  ),
  AmlCase(
    id: 'AML-1912',
    customer: 'Aurora Maritime AS',
    segment: 'Shipping',
    signal: 'H\u00f8y-risiko geografi',
    summary: 'Betaling via ny korrespondentbank',
    amount: 'kr 3,4 mill.',
    risk: 82,
    riskTone: 'high',
    status: 'Eskalert',
    statusTone: 'review',
    category: 'H\u00f8y',
    date: '23.04.2026',
    due: '28.04',
    owner: 'M. Nilsen',
    country: 'Norge / Singapore',
    kycLevel: 'oppdatert',
    beneficialOwner: 'Verifisert',
    beneficialOwnerOk: true,
    note: 'Handelsrute og betalingsbank er endret uten tilsvarende endring i kundeprofil.',
  ),
];

const transactionEvents = [
  TransactionEvent(
    caseId: 'AML-2048',
    time: '09:42',
    customer: 'Nordfjord Import AS',
    counterparty: 'LT Supply UAB',
    country: 'Litauen',
    amount: 'kr 410 000',
    scenario: 'Strukturering',
    risk: 96,
    tone: 'critical',
  ),
  TransactionEvent(
    caseId: 'AML-2035',
    time: '10:18',
    customer: 'Berg & Co Holding',
    counterparty: 'Delta X Finance',
    country: 'Kypros',
    amount: 'kr 980 000',
    scenario: 'Sanksjonstreff',
    risk: 88,
    tone: 'high',
  ),
  TransactionEvent(
    caseId: 'AML-2017',
    time: '11:07',
    customer: 'Elva Trading Ltd',
    counterparty: 'PEP Consulting',
    country: 'Storbritannia',
    amount: 'kr 1,3 mill.',
    scenario: 'PEP-motpart',
    risk: 79,
    tone: 'watch',
  ),
  TransactionEvent(
    caseId: 'AML-1988',
    time: '12:26',
    customer: 'Sj\u00f8lyst Konsulent',
    counterparty: 'Kontantinnskudd',
    country: 'Norge',
    amount: 'kr 640 000',
    scenario: 'Kontantprofil',
    risk: 84,
    tone: 'high',
  ),
  TransactionEvent(
    caseId: 'AML-1912',
    time: '13:15',
    customer: 'Aurora Maritime AS',
    counterparty: 'Harbor Gate Pte',
    country: 'Singapore',
    amount: 'kr 3,4 mill.',
    scenario: 'Geografi',
    risk: 82,
    tone: 'high',
  ),
];

const auditEvents = [
  AuditEvent('AML-2048 opprettet', 'Scenario STR-03 ga score 96 kl. 09:42.'),
  AuditEvent('Dokumentasjon etterspurt', 'KYC-oppdatering sendt til Elva Trading Ltd.'),
  AuditEvent('MLRO-varsling', 'Aurora Maritime AS er eskalert for vurdering.'),
  AuditEvent('Lavere risiko', 'M\u00f8llebyen Eiendom lukket etter eierskapskontroll.'),
];

const workflowActions = [
  WorkflowAction(
    id: 'onboard',
    title: 'Onboarde ny kunde',
    detail: 'Opprett kundesak, hent virksomhetsdata automatisk og start kundetiltak.',
    badge: 'MVP',
    icon: Icons.person_add_alt_1_rounded,
  ),
  WorkflowAction(
    id: 'refresh',
    title: 'Oppdatere eksisterende kunde',
    detail: 'Kj\u00f8r hendelsesbasert eller periodisk oppdatering av kundeprofil og dokumentasjon.',
    badge: 'L\u00f8pende',
    icon: Icons.refresh_rounded,
  ),
  WorkflowAction(
    id: 'ubo',
    title: 'Kontrollere reelle rettighetshavere',
    detail: 'Sammenstill registrerte opplysninger og AML-vurdering i samme sak.',
    badge: 'Brreg API',
    icon: Icons.account_tree_rounded,
  ),
  WorkflowAction(
    id: 'review',
    title: 'Gj\u00f8re periodisk AML-gjennomgang',
    detail: 'Oppdater KYC, eierskap, risiko og transaksjonsprofil etter intervall.',
    badge: 'Periodisk',
    icon: Icons.event_repeat_rounded,
  ),
  WorkflowAction(
    id: 'suspicion',
    title: 'Vurdere mistanke og forberede rapport',
    detail: 'G\u00e5 fra unders\u00f8kelser til intern vurdering og rapportutkast med revisjonsspor.',
    badge: 'MF-prosess',
    icon: Icons.policy_rounded,
  ),
];

const integrationStatuses = [
  IntegrationStatus(
    system: 'Brreg virksomhetsdata',
    state: 'API-klar',
    detail: 'Hent organisasjonsdata, status, roller, signatur og prokura fra autoritativ kilde.',
    access: 'Oppslag i sanntid',
    tone: 'normal',
  ),
  IntegrationStatus(
    system: 'Brreg reelle rettighetshavere',
    state: 'AML-kilde',
    detail: 'Bruk API-et for registrerte reelle rettighetshavere som del av kundetiltak og oppf\u00f8lging.',
    access: 'Tilgangsstyrt API',
    tone: 'review',
  ),
  IntegrationStatus(
    system: 'Altinn data.altinn.no',
    state: 'Datadeling',
    detail: 'Hent autoriserte datapakker fra kilden og be bare om opplysninger staten ikke allerede har.',
    access: 'API-n\u00f8kkel + Maskinporten',
    tone: 'normal',
  ),
  IntegrationStatus(
    system: 'Maskinporten',
    state: 'S2S-autentisering',
    detail: 'Sikre system-til-system kall med token og scopes per datakilde.',
    access: 'OAuth2 / JWT',
    tone: 'watch',
  ),
];

List<WorkflowTask> workflowTasksForAction(String workflowId) {
  return switch (workflowId) {
    'refresh' => const [
        WorkflowTask(
          title: 'Oppdater kundeprofil',
          detail: 'Hent nye virksomhetsopplysninger, roller og kontrollsignaler.',
          state: 'Auto',
          automation: 'Brreg-oppslag ved start',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Sammenlign mot tidligere vurdering',
          detail: 'Vis hva som er nytt siden siste kontroll og hva som krever re-godkjenning.',
          state: 'Auto',
          automation: 'Diff mot sist godkjente sak',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Bekreft avvik og mangler',
          detail: 'Stopp hvis legitimasjon, fullmakt eller eierskap ikke kan dokumenteres.',
          state: 'Vurder',
          automation: 'Regler og blokkeringer',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Oppdater risikoscore',
          detail: 'Beregn ny risiko og avgj\u00f8r om tiltak m\u00e5 skjerpes eller kan forenkles.',
          state: 'Vurder',
          automation: 'Regelmotor + manuell beslutning',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Arkiver oppdatert dokumentasjon',
          detail: 'Skriv revisjonsspor for hva som ble hentet, vurdert og besluttet.',
          state: 'Auto',
          automation: 'L\u00f8pende dokumentpakke',
          tone: 'closed',
        ),
      ],
    'ubo' => const [
        WorkflowTask(
          title: 'Hent registrerte rettighetshavere',
          detail: 'Sl\u00e5 opp registrerte opplysninger p\u00e5 organisasjonsnummer.',
          state: 'Auto',
          automation: 'Brreg UBO API',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Sammenstill kundens egne opplysninger',
          detail: 'Vis offentlig registrering ved siden av AML-vurdering og innsendt dokumentasjon.',
          state: 'Auto',
          automation: 'Sammenstilling i saksbildet',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Flagg motstrid eller uklar kontroll',
          detail: 'Skjul ikke avvik; vis b\u00e5de registrert opplysning og intern AML-vurdering.',
          state: 'Blokker',
          automation: 'Avviksregler',
          tone: 'critical',
        ),
        WorkflowTask(
          title: 'Avgj\u00f8r videre tiltak',
          detail: 'Velg om saken kan fortsette, m\u00e5 trappes opp eller krever ny dokumentinnhenting.',
          state: 'Vurder',
          automation: 'Regelmotor + manuell beslutning',
          tone: 'review',
        ),
      ],
    'review' => const [
        WorkflowTask(
          title: 'Start periodisk gjennomgang',
          detail: 'Opprett arbeidsliste basert p\u00e5 risikoklasse og neste forfallsdato.',
          state: 'Auto',
          automation: 'Planlagte p\u00e5minnelser',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Re-screen kunde og roller',
          detail: 'Kj\u00f8r sanksjon, PEP og endringer i eierskap eller virksomhetsprofil.',
          state: 'Auto',
          automation: 'Screening + registeroppslag',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Kontroller dokumentenes gyldighet',
          detail: 'Vis hvilke bevis som er utg\u00e5tt eller mangler for neste godkjenning.',
          state: 'Varsle',
          automation: 'Dokumentregler',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Oppdater beslutningslogg',
          detail: 'Skriv hva som ble kontrollert, hva som endret seg og hvorfor ny risiko ble satt.',
          state: 'Auto',
          automation: 'Automatisk revisjonsspor',
          tone: 'closed',
        ),
      ],
    'suspicion' => const [
        WorkflowTask(
          title: 'Samle grunnlag for mistanke',
          detail: 'Samle avvik, unders\u00f8kelser, transaksjoner og kundehistorikk i samme sak.',
          state: 'Auto',
          automation: 'Sakspakke fra arbeidsflaten',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Gjennomf\u00f8r interne unders\u00f8kelser',
          detail: 'Spor hva som er kontrollert og hva som fortsatt er uklart.',
          state: 'Vurder',
          automation: 'Oppgaveliste med sporbarhet',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Klargj\u00f8r MF-utkast',
          detail: 'Fyll ut sentrale felt med det som allerede er samlet i kundesaken.',
          state: 'Auto',
          automation: 'Rapportmodul',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Overlever til godkjenning',
          detail: 'Eskaler til MLRO eller tilsvarende funksjon f\u00f8r innsending.',
          state: 'Eskaler',
          automation: 'Beslutningsgate',
          tone: 'critical',
        ),
      ],
    _ => const [
        WorkflowTask(
          title: 'Identifiser kunde',
          detail: 'Hent virksomhetsdata automatisk og opprett sak med minimumsopplysninger.',
          state: 'Auto',
          automation: 'Brreg / Altinn',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Bekreft hvem som handler p\u00e5 vegne av virksomheten',
          detail: 'Sammenstill signatur, prokura, styre og fullmakter mot kundens representant.',
          state: 'Bekreft',
          automation: 'Registre + dokumentinnhenting',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Kartlegg reelle rettighetshavere',
          detail: 'Vis registrerte rettighetshavere og AML-vurdering side om side.',
          state: 'Auto',
          automation: 'Brreg UBO API',
          tone: 'closed',
        ),
        WorkflowTask(
          title: 'Vurder risiko',
          detail: 'Bruk risikofaktorer, geografi, PEP, eierstruktur og transaksjonssignal i samme bilde.',
          state: 'Vurder',
          automation: 'Regelmotor',
          tone: 'review',
        ),
        WorkflowTask(
          title: 'Avgj\u00f8r tiltak',
          detail: 'Foresl\u00e5 forenklet eller forsterket l\u00f8p, men krev beslutning ved h\u00f8y risiko.',
          state: 'Beslutning',
          automation: 'Forklarbar regelmotor',
          tone: 'high',
        ),
        WorkflowTask(
          title: 'Arkiver dokumentasjon',
          detail: 'Bygg dokumentpakke mens brukeren jobber, ikke til slutt.',
          state: 'Auto',
          automation: 'Revisjonsspor og PDF-pakke',
          tone: 'closed',
        ),
      ],
  };
}

List<RegistryComparison> registryComparisonsForCase(AmlCase selectedCase) {
  return [
    RegistryComparison(
      label: 'Virksomhet',
      registeredValue: '${selectedCase.customer} / aktiv virksomhet',
      amlValue: 'Sak ${selectedCase.id} er opprettet for videre kundetiltak.',
      detail: 'Organisasjonsdata hentes som grunnlag og kunden slipper dobbeltregistrering.',
      match: true,
    ),
    RegistryComparison(
      label: 'Roller og representasjon',
      registeredValue: 'Styre, signatur og prokura hentes fra offentlige registre.',
      amlValue: '${selectedCase.owner} er tildelt som ansvarlig analytiker; fullmakt m\u00e5 bekreftes.',
      detail: 'Den som handler p\u00e5 vegne av virksomheten m\u00e5 kunne knyttes til dokumentert rolle eller fullmakt.',
      match: selectedCase.status != 'Ny',
    ),
    RegistryComparison(
      label: 'Reelle rettighetshavere',
      registeredValue: selectedCase.beneficialOwner,
      amlValue: selectedCase.beneficialOwnerOk ? 'AML-vurdering samsvarer forel\u00f8pig.' : 'AML-vurdering krever manuell avklaring.',
      detail: 'Appen m\u00e5 vise b\u00e5de registrert opplysning og intern AML-vurdering n\u00e5r kriteriene ikke er helt like.',
      match: selectedCase.beneficialOwnerOk,
    ),
    RegistryComparison(
      label: 'Geografi og struktur',
      registeredValue: selectedCase.country,
      amlValue: selectedCase.category == 'PEP' || selectedCase.country.contains('/')
          ? 'Utl\u00f8ser utvidet vurdering av risiko og kundetiltak.'
          : 'Ingen s\u00e6rlige geografiske signaler identifisert.',
      detail: 'Utenlandsk eierskap, komplekse strukturer eller PEP-signal skal l\u00f8ftes tidlig.',
      match: !(selectedCase.category == 'PEP' || selectedCase.country.contains('/')),
    ),
  ];
}

List<DocumentStatus> documentStatusesForCase(AmlCase selectedCase) {
  return [
    const DocumentStatus(
      label: 'Brreg virksomhetsuttrekk',
      state: 'Vedlagt',
      source: 'Autoritativ kilde',
      tone: 'closed',
    ),
    const DocumentStatus(
      label: 'Roller, signatur og prokura',
      state: 'Vedlagt',
      source: 'Registeroppslag',
      tone: 'closed',
    ),
    DocumentStatus(
      label: 'Reelle rettighetshavere',
      state: selectedCase.beneficialOwnerOk ? 'Kontrollert' : 'Avklar',
      source: 'Brreg + AML-vurdering',
      tone: selectedCase.beneficialOwnerOk ? 'closed' : 'review',
    ),
    DocumentStatus(
      label: 'Legitimasjon / fullmakt',
      state: selectedCase.status == 'Dokument' ? 'Etterspurt' : 'Kreves',
      source: 'Kundedialog',
      tone: selectedCase.status == 'Dokument' ? 'watch' : 'review',
    ),
    DocumentStatus(
      label: 'Risikovurdering og beslutningslogg',
      state: 'L\u00f8pende',
      source: 'Genereres i saken',
      tone: 'normal',
    ),
  ];
}

List<RuleSuggestion> ruleSuggestionsForCase(AmlCase selectedCase) {
  final suggestions = <RuleSuggestion>[
    RuleSuggestion(
      title: 'Risikobasert tiltak',
      detail: selectedCase.risk >= 80
          ? 'Saken har h\u00f8y risiko og b\u00f8r ikke fullf\u00f8res uten forsterkede kundetiltak.'
          : 'Saken har moderat risiko og kan fortsette med standard eller forenklede tiltak dersom dokumentasjon holder.',
      recommendation: selectedCase.risk >= 80 ? 'Forsterket l\u00f8p' : 'Standard / forenklet l\u00f8p',
      tone: selectedCase.risk >= 80 ? 'critical' : 'medium',
    ),
    RuleSuggestion(
      title: 'Eierstruktur',
      detail: selectedCase.beneficialOwnerOk
          ? 'Registrerte opplysninger om reelle rettighetshavere er forel\u00f8pig forklarte.'
          : 'Eierstruktur eller registrering kan ikke forklares fullt ut med dagens underlag.',
      recommendation: selectedCase.beneficialOwnerOk ? 'Fortsett' : 'Manuell vurdering',
      tone: selectedCase.beneficialOwnerOk ? 'closed' : 'review',
    ),
  ];

  if (selectedCase.category == 'PEP' || selectedCase.signal.contains('PEP')) {
    suggestions.add(
      const RuleSuggestion(
        title: 'PEP eller n\u00e6r relasjon til PEP',
        detail: 'PEP-signal skal l\u00f8fte saken til forsterkede kundetiltak og tydelig godkjenningsflyt.',
        recommendation: 'Eskaler til utvidet kontroll',
        tone: 'critical',
      ),
    );
  } else if (selectedCase.country.contains('/')) {
    suggestions.add(
      const RuleSuggestion(
        title: 'Utenlandsk eierskap eller geografi',
        detail: 'Grensekryssende forhold og ny motpart gj\u00f8r at form\u00e5l, midlenes opprinnelse og struktur m\u00e5 forklares.',
        recommendation: 'Suppler dokumentasjon',
        tone: 'review',
      ),
    );
  } else {
    suggestions.add(
      const RuleSuggestion(
        title: 'Enklere struktur',
        detail: 'N\u00e5r struktur og aktivitet er konsistente, kan l\u00f8pet forenkles s\u00e5 lenge kundetiltakene fortsatt er tilstrekkelige.',
        recommendation: 'Vurder forenklet l\u00f8p',
        tone: 'medium',
      ),
    );
  }

  return suggestions;
}

List<ReviewIssue> reviewIssuesForCase(AmlCase selectedCase) {
  final issues = <ReviewIssue>[
    const ReviewIssue(
      title: 'Registrert opplysning vs AML-vurdering',
      detail: 'Appen skal vise hva registeret sier og hva virksomheten selv vurderer etter hvitvaskingsloven.',
      source: 'Kontrollpunkt',
      tone: 'review',
    ),
  ];

  if (!selectedCase.beneficialOwnerOk) {
    issues.add(
      ReviewIssue(
        title: 'Uavklart reell rettighetshaver',
        detail: 'Kunden kan ikke godkjennes f\u00f8r eierskap eller kontroll er forklart og dokumentert.',
        source: selectedCase.beneficialOwner,
        tone: 'critical',
      ),
    );
  }

  if (selectedCase.category == 'PEP' || selectedCase.signal.contains('PEP')) {
    issues.add(
      const ReviewIssue(
        title: 'PEP utløser forsterkede tiltak',
        detail: 'PEP-forhold krever skarpere kontroll og tydelig sporbar godkjenning.',
        source: 'Risikoregel',
        tone: 'critical',
      ),
    );
  }

  if (selectedCase.country.contains('/')) {
    issues.add(
      ReviewIssue(
        title: 'Kompleks geografi eller motpart',
        detail: 'Utenlandske ledd eller ny korrespondentbank m\u00e5 forklares med forretningsmessig form\u00e5l.',
        source: selectedCase.country,
        tone: 'high',
      ),
    );
  }

  return issues;
}

List<ReportStage> reportStagesForCase(AmlCase selectedCase) {
  return [
    ReportStage(
      title: 'Intern vurdering',
      detail: 'Sak ${selectedCase.id} samler grunnlag, egne vurderinger og relevante vedlegg.',
      complete: true,
    ),
    ReportStage(
      title: 'Unders\u00f8kelser',
      detail: 'Noter hvilke unders\u00f8kelser som er gjennomf\u00f8rt og hvilke forhold som fortsatt er uklare.',
      complete: selectedCase.status != 'Ny',
    ),
    ReportStage(
      title: 'Klargjort MF-utkast',
      detail: 'Forh\u00e5ndsfyll rapport med kunde, transaksjon, bakgrunn for mistanke og dokumentpakke.',
      complete: selectedCase.status == 'Eskalert',
    ),
    ReportStage(
      title: 'Oppf\u00f8lging',
      detail: 'Koble videre tiltak, sperring eller forsterket overv\u00e5king tilbake til samme sak.',
      complete: selectedCase.status == 'Eskalert',
    ),
  ];
}
