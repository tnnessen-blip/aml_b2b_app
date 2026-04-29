import 'package:flutter/material.dart';

import '../../../models/aml_case.dart';
import '../../../models/aml_customer.dart';
import '../../../models/transaction_event.dart';
import '../widgets/panels.dart';
import '../widgets/shared.dart';

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
                              child: FlowPanel(
                                range: chartRange,
                                onRangeChanged: onChartRangeChanged,
                              ),
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
                        Expanded(
                          child: FlowPanel(
                            range: chartRange,
                            onRangeChanged: onChartRangeChanged,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    PriorityPanel(
                      cases: priorityCases,
                      selectedId: selectedCase.id,
                      onSelectCase: onSelectCase,
                    ),
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
        final board = AlertBoard(
          cases: cases,
          selectedId: selectedCase.id,
          onSelectCase: onSelectCase,
        );
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
                  child: CustomerCard(
                    customer: customer,
                    onOpen: () => onOpenCustomer(customer.primaryCaseId),
                  ),
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
          detail: 'Scenario-treff, bel\u00f8p, geografi og motpart samlet i en arbeidsliste.',
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
            final summary = ReportSummary(
              escalated: escalated,
              closed: closed,
              total: cases.length,
            );
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
