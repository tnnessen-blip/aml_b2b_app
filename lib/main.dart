import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const AmlKontrollApp());
}

class AmlKontrollApp extends StatelessWidget {
  const AmlKontrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AML Kontrollrom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Arial',
        dividerColor: AppColors.line,
      ),
      home: const AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final _searchController = TextEditingController();
  AppSection _section = AppSection.overview;
  List<AmlCase> _cases = initialCases;
  String _selectedCaseId = initialCases.first.id;
  String _alertFilter = 'Alle';
  String _chartRange = '24 t';
  String _query = '';
  int _activeAlerts = 184;
  String _activeDelta = '+14';

  AmlCase get _selectedCase => _cases.firstWhere((item) => item.id == _selectedCaseId);

  List<AmlCase> get _filteredCases {
    final query = _query.trim().toLowerCase();
    return _cases.where((item) {
      final matchesFilter = _alertFilter == 'Alle' || item.category == _alertFilter || item.status == _alertFilter;
      final searchable = [
        item.id,
        item.customer,
        item.signal,
        item.amount,
        item.status,
        item.owner,
        item.country,
      ].join(' ').toLowerCase();
      return matchesFilter && searchable.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCase(String id) {
    setState(() => _selectedCaseId = id);
  }

  void _selectSection(AppSection section) {
    setState(() => _section = section);
  }

  void _setCaseStatus(String status, String tone) {
    setState(() {
      _cases = _cases.map((item) {
        if (item.id != _selectedCaseId) return item;
        return item.copyWith(status: status, statusTone: tone);
      }).toList();

      if (status == 'Lavere risiko') {
        _activeAlerts = math.max(_activeAlerts - 1, 0).toInt();
        _activeDelta = '+13';
      }
    });
  }

  void _assignSelectedCase(String owner) {
    setState(() {
      _cases = _cases.map((item) {
        if (item.id != _selectedCaseId) return item;
        return item.copyWith(owner: owner, status: 'Vurderes', statusTone: 'review');
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1120;
        final content = AppContent(
          section: _section,
          cases: _cases,
          filteredCases: _filteredCases,
          selectedCase: _selectedCase,
          alertFilter: _alertFilter,
          chartRange: _chartRange,
          activeAlerts: _activeAlerts,
          activeDelta: _activeDelta,
          searchController: _searchController,
          onSearchChanged: (value) => setState(() => _query = value),
          onAlertFilterChanged: (value) => setState(() => _alertFilter = value),
          onChartRangeChanged: (value) => setState(() => _chartRange = value),
          onSelectCase: _selectCase,
          onEscalate: () => _setCaseStatus('Eskalert', 'review'),
          onClearRisk: () => _setCaseStatus('Lavere risiko', 'closed'),
          onAssign: _assignSelectedCase,
        );

        return Scaffold(
          body: SafeArea(
            child: wide
                ? Row(
                    children: [
                      SideNavigation(section: _section, onChanged: _selectSection),
                      Expanded(child: content),
                    ],
                  )
                : Column(
                    children: [
                      MobileNavigation(section: _section, onChanged: _selectSection),
                      Expanded(child: content),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({
    required this.section,
    required this.cases,
    required this.filteredCases,
    required this.selectedCase,
    required this.alertFilter,
    required this.chartRange,
    required this.activeAlerts,
    required this.activeDelta,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAlertFilterChanged,
    required this.onChartRangeChanged,
    required this.onSelectCase,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final AppSection section;
  final List<AmlCase> cases;
  final List<AmlCase> filteredCases;
  final AmlCase selectedCase;
  final String alertFilter;
  final String chartRange;
  final int activeAlerts;
  final String activeDelta;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onAlertFilterChanged;
  final ValueChanged<String> onChartRangeChanged;
  final ValueChanged<String> onSelectCase;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderBar(controller: searchController, onChanged: onSearchChanged),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (section) {
              AppSection.overview => OverviewView(
                  key: const ValueKey('overview'),
                  cases: cases,
                  filteredCases: filteredCases,
                  selectedCase: selectedCase,
                  activeAlerts: activeAlerts,
                  activeDelta: activeDelta,
                  alertFilter: alertFilter,
                  chartRange: chartRange,
                  onAlertFilterChanged: onAlertFilterChanged,
                  onChartRangeChanged: onChartRangeChanged,
                  onSelectCase: onSelectCase,
                  onEscalate: onEscalate,
                  onClearRisk: onClearRisk,
                  onAssign: onAssign,
                ),
              AppSection.alerts => AlertsView(
                  key: const ValueKey('alerts'),
                  cases: filteredCases,
                  selectedCase: selectedCase,
                  filter: alertFilter,
                  onFilterChanged: onAlertFilterChanged,
                  onSelectCase: onSelectCase,
                  onEscalate: onEscalate,
                  onClearRisk: onClearRisk,
                  onAssign: onAssign,
                ),
              AppSection.customers => CustomersView(
                  key: const ValueKey('customers'),
                  customers: customersFromCases(cases),
                  onOpenCustomer: onSelectCase,
                ),
              AppSection.transactions => TransactionsView(
                  key: const ValueKey('transactions'),
                  transactions: transactionEvents,
                  onSelectCase: onSelectCase,
                ),
              AppSection.reports => ReportsView(
                  key: const ValueKey('reports'),
                  cases: cases,
                  selectedCase: selectedCase,
                ),
            },
          ),
        ],
      ),
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({
    required this.cases,
    required this.filteredCases,
    required this.selectedCase,
    required this.activeAlerts,
    required this.activeDelta,
    required this.alertFilter,
    required this.chartRange,
    required this.onAlertFilterChanged,
    required this.onChartRangeChanged,
    required this.onSelectCase,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final List<AmlCase> cases;
  final List<AmlCase> filteredCases;
  final AmlCase selectedCase;
  final int activeAlerts;
  final String activeDelta;
  final String alertFilter;
  final String chartRange;
  final ValueChanged<String> onAlertFilterChanged;
  final ValueChanged<String> onChartRangeChanged;
  final ValueChanged<String> onSelectCase;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1080;
        final medium = constraints.maxWidth >= 760;
        final priorityCases = cases.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MetricGrid(
              activeAlerts: activeAlerts,
              activeDelta: activeDelta,
              openCases: cases.where((item) => item.status != 'Lavere risiko').length,
              sanctions: cases.where((item) => item.category == 'Sanksjon').length,
            ),
            const SizedBox(height: 16),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: PriorityPanel(
                                cases: priorityCases,
                                selectedId: selectedCase.id,
                                onSelectCase: onSelectCase,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 6,
                              child: FlowPanel(range: chartRange, onRangeChanged: onChartRangeChanged),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CaseQueuePanel(
                          cases: filteredCases,
                          filter: alertFilter,
                          selectedId: selectedCase.id,
                          onFilterChanged: onAlertFilterChanged,
                          onSelectCase: onSelectCase,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 360,
                    child: SideStack(
                      selectedCase: selectedCase,
                      chartRange: chartRange,
                      onEscalate: onEscalate,
                      onClearRisk: onClearRisk,
                      onAssign: onAssign,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  if (medium)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PriorityPanel(
                            cases: priorityCases,
                            selectedId: selectedCase.id,
                            onSelectCase: onSelectCase,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: FlowPanel(range: chartRange, onRangeChanged: onChartRangeChanged)),
                      ],
                    )
                  else ...[
                    PriorityPanel(cases: priorityCases, selectedId: selectedCase.id, onSelectCase: onSelectCase),
                    const SizedBox(height: 16),
                    FlowPanel(range: chartRange, onRangeChanged: onChartRangeChanged),
                  ],
                  const SizedBox(height: 16),
                  CaseQueuePanel(
                    cases: filteredCases,
                    filter: alertFilter,
                    selectedId: selectedCase.id,
                    onFilterChanged: onAlertFilterChanged,
                    onSelectCase: onSelectCase,
                  ),
                  const SizedBox(height: 16),
                  SideStack(
                    selectedCase: selectedCase,
                    chartRange: chartRange,
                    onEscalate: onEscalate,
                    onClearRisk: onClearRisk,
                    onAssign: onAssign,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class AlertsView extends StatelessWidget {
  const AlertsView({
    required this.cases,
    required this.selectedCase,
    required this.filter,
    required this.onFilterChanged,
    required this.onSelectCase,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final List<AmlCase> cases;
  final AmlCase selectedCase;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSelectCase;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 980;
        final board = AlertBoard(cases: cases, selectedId: selectedCase.id, onSelectCase: onSelectCase);
        final details = ProfilePanel(
          selectedCase: selectedCase,
          onEscalate: onEscalate,
          onClearRisk: onClearRisk,
          onAssign: onAssign,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle(
              eyebrow: 'Operativ k\u00f8',
              title: 'Varsler og saksbehandling',
              detail: 'Arbeid fra ny alert til dokumentert beslutning.',
              trailing: SegmentedButtons(
                values: const ['Alle', 'H\u00f8y', 'PEP', 'Sanksjon', 'Ny', 'Eskalert'],
                selected: filter,
                onChanged: onFilterChanged,
              ),
            ),
            const SizedBox(height: 16),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: board),
                  const SizedBox(width: 16),
                  SizedBox(width: 380, child: details),
                ],
              )
            else ...[
              board,
              const SizedBox(height: 16),
              details,
            ],
          ],
        );
      },
    );
  }
}

class CustomersView extends StatelessWidget {
  const CustomersView({required this.customers, required this.onOpenCustomer, super.key});

  final List<AmlCustomer> customers;
  final ValueChanged<String> onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          eyebrow: 'KYC og kundekontroll',
          title: 'Kunder med aktiv risiko',
          detail: 'Oversikt over risikoprofil, reell eier, PEP/sanksjon og neste tiltak.',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1180
                ? 3
                : constraints.maxWidth >= 760
                    ? 2
                    : 1;
            final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: customers.map((customer) {
                return SizedBox(
                  width: width,
                  child: CustomerCard(customer: customer, onOpen: () => onOpenCustomer(customer.primaryCaseId)),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({required this.transactions, required this.onSelectCase, super.key});

  final List<TransactionEvent> transactions;
  final ValueChanged<String> onSelectCase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          eyebrow: 'Overv\u00e5king',
          title: 'Transaksjoner og scenarioer',
          detail: 'Scenario-treff, bel\u00f8p, geografi og motpart samlet i én arbeidsliste.',
        ),
        const SizedBox(height: 16),
        AppPanel(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('Tid')),
                DataColumn(label: Text('Kunde')),
                DataColumn(label: Text('Motpart')),
                DataColumn(label: Text('Land')),
                DataColumn(label: Text('Bel\u00f8p')),
                DataColumn(label: Text('Scenario')),
                DataColumn(label: Text('Risiko')),
              ],
              rows: transactions.map((item) {
                return DataRow(
                  onSelectChanged: (_) => onSelectCase(item.caseId),
                  cells: [
                    DataCell(Text(item.time)),
                    DataCell(Text(item.customer)),
                    DataCell(Text(item.counterparty)),
                    DataCell(Text(item.country)),
                    DataCell(Text(item.amount)),
                    DataCell(Text(item.scenario)),
                    DataCell(StatusPill(label: '${item.risk}', tone: item.tone)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportsView extends StatelessWidget {
  const ReportsView({required this.cases, required this.selectedCase, super.key});

  final List<AmlCase> cases;
  final AmlCase selectedCase;

  @override
  Widget build(BuildContext context) {
    final escalated = cases.where((item) => item.status == 'Eskalert').length;
    final closed = cases.where((item) => item.status == 'Lavere risiko').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          eyebrow: 'Dokumentasjon',
          title: 'Rapporter og revisjonsspor',
          detail: 'Forbered STR/MT-rapportering, intern kontroll og styregrunnlag.',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            final summary = ReportSummary(escalated: escalated, closed: closed, total: cases.length);
            final draft = ReportDraftPanel(selectedCase: selectedCase);
            final audit = const AuditTrailPanel();

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: summary),
                  const SizedBox(width: 16),
                  Expanded(child: draft),
                  const SizedBox(width: 16),
                  Expanded(child: audit),
                ],
              );
            }
            return Column(
              children: [
                summary,
                const SizedBox(height: 16),
                draft,
                const SizedBox(height: 16),
                audit,
              ],
            );
          },
        ),
      ],
    );
  }
}

class SideNavigation extends StatelessWidget {
  const SideNavigation({required this.section, required this.onChanged, super.key});

  final AppSection section;
  final ValueChanged<AppSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 276,
      color: AppColors.ink,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandBlock(),
          const SizedBox(height: 28),
          ...AppSection.values.map((item) => NavButton(section: item, active: item == section, onTap: onChanged)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF312C27),
              border: Border.all(color: const Color(0xFF494139)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kontrolldekning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    Text('94%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(value: 0.94, color: Color(0xFF62B7A9), backgroundColor: Color(0xFF494139)),
                SizedBox(height: 12),
                Text(
                  'Sanntidsscreening, KYC og transaksjonsm\u00f8nstre er koblet til dagens k\u00f8.',
                  style: TextStyle(color: Color(0xFFC8C0B6), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileNavigation extends StatelessWidget {
  const MobileNavigation({required this.section, required this.onChanged, super.key});

  final AppSection section;
  final ValueChanged<AppSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
                BrandMark(),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AML Kontroll',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: AppSection.values.map((item) {
                final active = item == section;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    selected: active,
                    showCheckmark: false,
                    avatar: Icon(item.icon, size: 18, color: active ? AppColors.ink : Colors.white),
                    label: Text(item.label),
                    labelStyle: TextStyle(color: active ? AppColors.ink : Colors.white, fontWeight: FontWeight.w800),
                    selectedColor: const Color(0xFFE6F2EF),
                    backgroundColor: const Color(0xFF36312B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onSelected: (_) => onChanged(item),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderBar extends StatelessWidget {
  const HeaderBar({required this.controller, required this.onChanged, super.key});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        final search = SizedBox(
          width: compact ? double.infinity : 390,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'S\u00f8k kunde, sak eller bel\u00f8p',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'T\u00f8m s\u00f8k',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.line),
              ),
            ),
          ),
        );

        final title = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('28. april 2026'),
            SizedBox(height: 4),
            Text('Operativ oversikt', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.1)),
          ],
        );

        if (compact) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 12), search]);
        }

        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [title, search]);
      },
    );
  }
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({
    required this.activeAlerts,
    required this.activeDelta,
    required this.openCases,
    required this.sanctions,
    super.key,
  });

  final int activeAlerts;
  final String activeDelta;
  final int openCases;
  final int sanctions;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      Metric('Risikoindeks', '72', '+8', 'Over terskel i bedriftsportef\u00f8ljen', 'critical'),
      Metric('Aktive varsler', '$activeAlerts', activeDelta, '63 krever vurdering innen 24 t', 'normal'),
      Metric('\u00c5pne saker', '$openCases', 'live', 'Saker fordelt p\u00e5 analytikere', 'high'),
      Metric('Sanksjonstreff', '$sanctions', '3 nye', '2 med h\u00f8y navnelikhet', 'watch'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 640
                ? 2
                : 1;
        final width = (constraints.maxWidth - (columns - 1) * 14) / columns;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: metrics.map((metric) => SizedBox(width: width, child: MetricCard(metric: metric))).toList(),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({required this.metric, super.key});

  final Metric metric;

  @override
  Widget build(BuildContext context) {
    final accent = toneColor(metric.tone);

    return AppPanel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 4, color: accent),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(metric.label, style: const TextStyle(color: AppColors.muted, fontSize: 12))),
                      Text(metric.delta, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(metric.value, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(metric.detail, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityPanel extends StatelessWidget {
  const PriorityPanel({required this.cases, required this.selectedId, required this.onSelectCase, super.key});

  final List<AmlCase> cases;
  final String selectedId;
  final ValueChanged<String> onSelectCase;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Triagering', title: 'Dagens prioritet', trailing: Text('Tildel')),
          const SizedBox(height: 14),
          ...cases.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CaseListTile(
                item: item,
                active: item.id == selectedId,
                onTap: () => onSelectCase(item.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlowPanel extends StatelessWidget {
  const FlowPanel({required this.range, required this.onRangeChanged, super.key});

  final String range;
  final ValueChanged<String> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelHeader(
            eyebrow: 'Transaksjonsnettverk',
            title: 'Flytanalyse',
            trailing: SegmentedButtons(values: const ['24 t', '7 d', '30 d'], selected: range, onChanged: onRangeChanged),
          ),
          const SizedBox(height: 14),
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: AppColors.surfaceStrong,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(painter: FlowPainter()),
          ),
        ],
      ),
    );
  }
}

class CaseQueuePanel extends StatelessWidget {
  const CaseQueuePanel({
    required this.cases,
    required this.filter,
    required this.selectedId,
    required this.onFilterChanged,
    required this.onSelectCase,
    super.key,
  });

  final List<AmlCase> cases;
  final String filter;
  final String selectedId;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSelectCase;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelHeader(
            eyebrow: 'Varselk\u00f8',
            title: 'Saker til vurdering',
            trailing: SegmentedButtons(
              values: const ['Alle', 'H\u00f8y', 'PEP', 'Sanksjon'],
              selected: filter,
              onChanged: onFilterChanged,
            ),
          ),
          const SizedBox(height: 14),
          if (cases.isEmpty)
            const EmptyState(message: 'Ingen saker matcher filteret.')
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('Sak')),
                  DataColumn(label: Text('Kunde')),
                  DataColumn(label: Text('Signal')),
                  DataColumn(label: Text('Bel\u00f8p')),
                  DataColumn(label: Text('Eier')),
                  DataColumn(label: Text('Risiko')),
                  DataColumn(label: Text('Status')),
                ],
                rows: cases
                    .map(
                      (item) => DataRow(
                        selected: item.id == selectedId,
                        onSelectChanged: (_) => onSelectCase(item.id),
                        cells: [
                          DataCell(Text(item.id)),
                          DataCell(Text(item.customer)),
                          DataCell(Text(item.signal)),
                          DataCell(Text(item.amount)),
                          DataCell(Text(item.owner)),
                          DataCell(StatusPill(label: '${item.risk}', tone: item.riskTone)),
                          DataCell(StatusPill(label: item.status, tone: item.statusTone)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class AlertBoard extends StatelessWidget {
  const AlertBoard({required this.cases, required this.selectedId, required this.onSelectCase, super.key});

  final List<AmlCase> cases;
  final String selectedId;
  final ValueChanged<String> onSelectCase;

  @override
  Widget build(BuildContext context) {
    final columns = ['Ny', 'Vurderes', 'Dokument', 'Eskalert', 'Lavere risiko'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.map((status) {
          final items = cases.where((item) => item.status == status).toList();
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 12),
            child: AppPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(status, style: const TextStyle(fontWeight: FontWeight.w900)),
                      StatusPill(label: '${items.length}', tone: status == 'Eskalert' ? 'review' : 'normal'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const EmptyState(message: 'Tom kolonne')
                  else
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CaseListTile(
                          item: item,
                          active: item.id == selectedId,
                          onTap: () => onSelectCase(item.id),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SideStack extends StatelessWidget {
  const SideStack({
    required this.selectedCase,
    required this.chartRange,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final AmlCase selectedCase;
  final String chartRange;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfilePanel(
          selectedCase: selectedCase,
          onEscalate: onEscalate,
          onClearRisk: onClearRisk,
          onAssign: onAssign,
        ),
        const SizedBox(height: 16),
        ScenarioPanel(range: chartRange),
        const SizedBox(height: 16),
        const RegionPanel(),
      ],
    );
  }
}

class ProfilePanel extends StatelessWidget {
  const ProfilePanel({
    required this.selectedCase,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final AmlCase selectedCase;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHeader(
            eyebrow: 'Kundeprofil',
            title: selectedCase.customer,
            trailing: StatusPill(label: '${selectedCase.risk}', tone: selectedCase.riskTone),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              InfoTile(label: 'Sak', value: selectedCase.id),
              InfoTile(label: 'Eksponering', value: selectedCase.amount),
              InfoTile(label: 'Frist', value: selectedCase.due),
              InfoTile(label: 'Eier', value: selectedCase.owner),
            ],
          ),
          const SizedBox(height: 14),
          Text(selectedCase.note, style: const TextStyle(color: AppColors.muted, height: 1.4)),
          const SizedBox(height: 14),
          const ChecklistRow(label: 'KYC oppdatert', checked: true),
          ChecklistRow(label: 'Reell eier: ${selectedCase.beneficialOwner}', checked: selectedCase.beneficialOwnerOk),
          ChecklistRow(label: 'Eskalert til MLRO', checked: selectedCase.status == 'Eskalert'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(onPressed: onEscalate, icon: const Icon(Icons.priority_high_rounded), label: const Text('Eskaler')),
              OutlinedButton.icon(onPressed: onClearRisk, icon: const Icon(Icons.check_rounded), label: const Text('Lavere risiko')),
              PopupMenuButton<String>(
                tooltip: 'Tildel analytiker',
                onSelected: onAssign,
                itemBuilder: (context) => analysts.map((owner) => PopupMenuItem(value: owner, child: Text(owner))).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Tildel', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScenarioPanel extends StatelessWidget {
  const ScenarioPanel({required this.range, super.key});

  final String range;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PanelHeader(eyebrow: 'Scenarioer', title: 'Treff siste 8 uker', trailing: Text('+12%')),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: CustomPaint(painter: TrendPainter(range))),
        ],
      ),
    );
  }
}

class RegionPanel extends StatelessWidget {
  const RegionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final regions = [
      ('\u00d8st-Europa', 41, AppColors.teal),
      ('Norden', 28, AppColors.amber),
      ('Midt\u00f8sten', 19, AppColors.red),
      ('Asia', 14, AppColors.indigo),
    ];

    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Geografi', title: 'H\u00f8y-risiko regioner'),
          const SizedBox(height: 12),
          ...regions.map(
            (region) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceStrong,
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: math.min(region.$2 / 50, 1.0).toDouble(),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: region.$3.withAlpha(36),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(region.$1),
                          Text('${region.$2}', style: const TextStyle(fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({required this.customer, required this.onOpen, super.key});

  final AmlCustomer customer;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(customer.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
              StatusPill(label: '${customer.risk}', tone: customer.riskTone),
            ],
          ),
          const SizedBox(height: 10),
          Text(customer.segment, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 14),
          InfoTile(label: 'Land', value: customer.country),
          const SizedBox(height: 10),
          InfoTile(label: 'Eier', value: customer.owner),
          const SizedBox(height: 10),
          ChecklistRow(label: 'KYC ${customer.kycLevel}', checked: customer.kycLevel != 'mangler'),
          ChecklistRow(label: 'Reell eier avklart', checked: customer.ownerVerified),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(onPressed: onOpen, child: const Text('\u00c5pne sak')),
          ),
        ],
      ),
    );
  }
}

class ReportSummary extends StatelessWidget {
  const ReportSummary({required this.escalated, required this.closed, required this.total, super.key});

  final int escalated;
  final int closed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Status', title: 'Rapportgrunnlag'),
          const SizedBox(height: 14),
          MetricLine(label: 'Totale saker', value: total),
          MetricLine(label: 'Eskalert til MLRO', value: escalated),
          MetricLine(label: 'Lukket lavere risiko', value: closed),
          MetricLine(label: 'Klar for STR-utkast', value: escalated + 2),
        ],
      ),
    );
  }
}

class ReportDraftPanel extends StatelessWidget {
  const ReportDraftPanel({required this.selectedCase, super.key});

  final AmlCase selectedCase;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Utkast', title: 'Rapporteringspakke'),
          const SizedBox(height: 14),
          Text('Sak ${selectedCase.id}', style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(selectedCase.note, style: const TextStyle(color: AppColors.muted, height: 1.4)),
          const SizedBox(height: 14),
          const ChecklistRow(label: 'Transaksjonsgrunnlag vedlagt', checked: true),
          const ChecklistRow(label: 'KYC-dokumentasjon vedlagt', checked: true),
          const ChecklistRow(label: 'MLRO-beslutning signert', checked: false),
        ],
      ),
    );
  }
}

class AuditTrailPanel extends StatelessWidget {
  const AuditTrailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Revisjon', title: 'Siste hendelser'),
          const SizedBox(height: 14),
          ...auditEvents.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.history_rounded, color: AppColors.teal, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(event.detail, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaseListTile extends StatelessWidget {
  const CaseListTile({required this.item, required this.active, required this.onTap, super.key});

  final AmlCase item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEEF8F5) : AppColors.surfaceStrong,
          border: Border.all(color: active ? const Color(0xFF9ECDC5) : AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            RiskDot(tone: item.riskTone),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.customer, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(item.summary, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            Text('${item.risk}', style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.eyebrow, required this.title, required this.detail, this.trailing, super.key});

  final String eyebrow;
  final String title;
  final String detail;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(eyebrow),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(detail, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({required this.eyebrow, required this.title, this.trailing, super.key});

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel({required this.child, this.padding = const EdgeInsets.all(18), super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x14231F19), blurRadius: 35, offset: Offset(0, 14))],
      ),
      child: child,
    );
  }
}

class BrandBlock extends StatelessWidget {
  const BrandBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        BrandMark(),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AML Kontroll', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            SizedBox(height: 2),
            Text('Hvitvasking', style: TextStyle(color: Color(0xFFC8C0B6), fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.verified_user_rounded, color: AppColors.tealDark),
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton({required this.section, required this.active, required this.onTap, super.key});

  final AppSection section;
  final bool active;
  final ValueChanged<AppSection> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF36312B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(section.icon, color: Colors.white),
        title: Text(section.label, style: const TextStyle(color: Colors.white)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: () => onTap(section),
      ),
    );
  }
}

class SegmentedButtons extends StatelessWidget {
  const SegmentedButtons({required this.values, required this.selected, required this.onChanged, super.key});

  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: values.map((value) {
        final active = value == selected;
        return ChoiceChip(
          label: Text(value),
          selected: active,
          showCheckmark: false,
          selectedColor: AppColors.ink,
          labelStyle: TextStyle(color: active ? Colors.white : AppColors.muted, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onSelected: (_) => onChanged(value),
        );
      }).toList(),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w800),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 96, maxWidth: 160),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
        ],
      ),
    );
  }
}

class ChecklistRow extends StatelessWidget {
  const ChecklistRow({required this.label, required this.checked, super.key});

  final String label;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
            color: checked ? AppColors.teal : AppColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.tone, super.key});

  final String label;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final color = toneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withAlpha(41), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }
}

class RiskDot extends StatelessWidget {
  const RiskDot({required this.tone, super.key});

  final String tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: toneColor(tone), shape: BoxShape.circle),
    );
  }
}

class MetricLine extends StatelessWidget {
  const MetricLine({required this.label, required this.value, super.key});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message, style: const TextStyle(color: AppColors.muted)),
    );
  }
}

class FlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 640;
    final scaleY = size.height / 300;
    Offset p(double x, double y) => Offset(x * scaleX, y * scaleY);

    final gridPaint = Paint()
      ..color = AppColors.line.withAlpha(140)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    void drawFlow(List<Offset> points, Color color) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var index = 1; index < points.length; index += 3) {
        if (index + 2 < points.length) {
          path.cubicTo(
            points[index].dx,
            points[index].dy,
            points[index + 1].dx,
            points[index + 1].dy,
            points[index + 2].dx,
            points[index + 2].dy,
          );
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    drawFlow([p(116, 143), p(214, 48), p(307, 57), p(395, 117)], AppColors.red);
    drawFlow([p(124, 161), p(234, 233), p(335, 233), p(474, 184)], AppColors.amber);
    drawFlow([p(404, 132), p(485, 93), p(543, 103), p(590, 152)], const Color(0xFF708C88));
    drawFlow([p(385, 146), p(307, 181), p(247, 199), p(181, 219)], AppColors.red);

    final nodes = [
      (p(104, 152), 33.0 * scaleX, 'NI', AppColors.red),
      (p(402, 128), 26.0 * scaleX, 'DX', AppColors.amber),
      (p(494, 180), 22.0 * scaleX, 'PEP', AppColors.green),
      (p(595, 156), 18.0 * scaleX, 'HK', AppColors.teal),
      (p(175, 221), 21.0 * scaleX, 'LT', AppColors.indigo),
    ];

    for (final node in nodes) {
      canvas.drawCircle(node.$1, node.$2, Paint()..color = Colors.white);
      canvas.drawCircle(node.$1, node.$2 - 3, Paint()..color = node.$4);
      final painter = TextPainter(
        text: TextSpan(text: node.$3, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, node.$1 - Offset(painter.width / 2, painter.height / 2 + 3));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrendPainter extends CustomPainter {
  TrendPainter(this.range);

  final String range;

  @override
  void paint(Canvas canvas, Size size) {
    final values = switch (range) {
      '7 d' => [44, 39, 48, 53, 57, 62, 69, 76],
      '30 d' => [58, 61, 56, 64, 72, 70, 82, 91],
      _ => [18, 25, 21, 34, 29, 43, 52, 61],
    };
    final minValue = values.reduce((a, b) => a < b ? a : b) - 10;
    final maxValue = values.reduce((a, b) => a > b ? a : b) + 10;
    const padding = 22.0;

    final gridPaint = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i += 1) {
      final y = padding + i * ((size.height - padding * 2) / 3);
      canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), gridPaint);
    }

    final points = <Offset>[];
    for (var i = 0; i < values.length; i += 1) {
      final x = padding + i * ((size.width - padding * 2) / (values.length - 1));
      final y = size.height - padding - ((values[i] - minValue) / (maxValue - minValue)) * (size.height - padding * 2);
      points.add(Offset(x, y));
    }

    final fillPath = Path()
      ..moveTo(points.first.dx, size.height - padding)
      ..addPolygon(points, false)
      ..lineTo(points.last.dx, size.height - padding)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = AppColors.teal.withAlpha(38));

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.white);
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = AppColors.teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) => oldDelegate.range != range;
}

Color toneColor(String tone) {
  return switch (tone) {
    'critical' => AppColors.red,
    'high' => AppColors.amber,
    'watch' => AppColors.indigo,
    'medium' => AppColors.green,
    'review' => AppColors.amber,
    'closed' => AppColors.green,
    _ => AppColors.teal,
  };
}

List<AmlCustomer> customersFromCases(List<AmlCase> cases) {
  return cases.map((item) {
    return AmlCustomer(
      name: item.customer,
      primaryCaseId: item.id,
      segment: item.segment,
      country: item.country,
      owner: item.owner,
      risk: item.risk,
      riskTone: item.riskTone,
      kycLevel: item.kycLevel,
      ownerVerified: item.beneficialOwnerOk,
    );
  }).toList();
}

enum AppSection {
  overview('Oversikt', Icons.dashboard_rounded),
  alerts('Varsler', Icons.security_rounded),
  customers('Kunder', Icons.person_search_rounded),
  transactions('Transaksjoner', Icons.sync_alt_rounded),
  reports('Rapporter', Icons.description_rounded);

  const AppSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

class AppColors {
  static const background = Color(0xFFF5F2EC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceStrong = Color(0xFFFBFAF7);
  static const ink = Color(0xFF25211D);
  static const muted = Color(0xFF6F675F);
  static const line = Color(0xFFDED8CF);
  static const teal = Color(0xFF0F7C74);
  static const tealDark = Color(0xFF0A5D57);
  static const indigo = Color(0xFF4D5AA6);
  static const amber = Color(0xFFC78021);
  static const red = Color(0xFFB7433A);
  static const green = Color(0xFF487B3F);
}

class AmlCase {
  const AmlCase({
    required this.id,
    required this.customer,
    required this.segment,
    required this.signal,
    required this.summary,
    required this.amount,
    required this.risk,
    required this.riskTone,
    required this.status,
    required this.statusTone,
    required this.category,
    required this.date,
    required this.due,
    required this.owner,
    required this.country,
    required this.kycLevel,
    required this.beneficialOwner,
    required this.beneficialOwnerOk,
    required this.note,
  });

  final String id;
  final String customer;
  final String segment;
  final String signal;
  final String summary;
  final String amount;
  final int risk;
  final String riskTone;
  final String status;
  final String statusTone;
  final String category;
  final String date;
  final String due;
  final String owner;
  final String country;
  final String kycLevel;
  final String beneficialOwner;
  final bool beneficialOwnerOk;
  final String note;

  AmlCase copyWith({String? status, String? statusTone, String? owner}) {
    return AmlCase(
      id: id,
      customer: customer,
      segment: segment,
      signal: signal,
      summary: summary,
      amount: amount,
      risk: risk,
      riskTone: riskTone,
      status: status ?? this.status,
      statusTone: statusTone ?? this.statusTone,
      category: category,
      date: date,
      due: due,
      owner: owner ?? this.owner,
      country: country,
      kycLevel: kycLevel,
      beneficialOwner: beneficialOwner,
      beneficialOwnerOk: beneficialOwnerOk,
      note: note,
    );
  }
}

class AmlCustomer {
  const AmlCustomer({
    required this.name,
    required this.primaryCaseId,
    required this.segment,
    required this.country,
    required this.owner,
    required this.risk,
    required this.riskTone,
    required this.kycLevel,
    required this.ownerVerified,
  });

  final String name;
  final String primaryCaseId;
  final String segment;
  final String country;
  final String owner;
  final int risk;
  final String riskTone;
  final String kycLevel;
  final bool ownerVerified;
}

class TransactionEvent {
  const TransactionEvent({
    required this.caseId,
    required this.time,
    required this.customer,
    required this.counterparty,
    required this.country,
    required this.amount,
    required this.scenario,
    required this.risk,
    required this.tone,
  });

  final String caseId;
  final String time;
  final String customer;
  final String counterparty;
  final String country;
  final String amount;
  final String scenario;
  final int risk;
  final String tone;
}

class Metric {
  const Metric(this.label, this.value, this.delta, this.detail, this.tone);

  final String label;
  final String value;
  final String delta;
  final String detail;
  final String tone;
}

class AuditEvent {
  const AuditEvent(this.title, this.detail);

  final String title;
  final String detail;
}

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
