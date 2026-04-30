import 'package:flutter/material.dart';

import '../../../data/demo_data.dart';
import '../../../models/aml_case.dart';
import '../../../models/aml_customer.dart';
import '../../../models/transaction_event.dart';
import '../widgets/automation_panels.dart';
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
    required this.activeWorkflowId,
    required this.onAlertFilterChanged,
    required this.onChartRangeChanged,
    required this.onWorkflowSelected,
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
  final String activeWorkflowId;
  final ValueChanged<String> onAlertFilterChanged;
  final ValueChanged<String> onChartRangeChanged;
  final ValueChanged<String> onWorkflowSelected;
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
        final workflowTasks = workflowTasksForAction(activeWorkflowId);
        final registryComparisons = registryComparisonsForCase(selectedCase);
        final ruleSuggestions = ruleSuggestionsForCase(selectedCase);
        final reviewIssues = reviewIssuesForCase(selectedCase);
        final documentStatuses = documentStatusesForCase(selectedCase);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WorkflowLauncherPanel(
              actions: workflowActions,
              selectedId: activeWorkflowId,
              onSelected: onWorkflowSelected,
            ),
            const SizedBox(height: 16),
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
                        CustomerCasePanel(
                          selectedCase: selectedCase,
                          comparisons: registryComparisons,
                          documents: documentStatuses,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: WorkflowChecklistPanel(
                                tasks: workflowTasks,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 6,
                              child: RuleEnginePanel(
                                suggestions: ruleSuggestions,
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
                        const SizedBox(height: 16),
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 360,
                    child: Column(
                      children: [
                        const IntegrationStatusPanel(items: integrationStatuses),
                        const SizedBox(height: 16),
                        ReviewIssuesPanel(issues: reviewIssues),
                        const SizedBox(height: 16),
                        DocumentationPanel(selectedCase: selectedCase),
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
                  ),
                ],
              )
            else
              Column(
                children: [
                  CustomerCasePanel(
                    selectedCase: selectedCase,
                    comparisons: registryComparisons,
                    documents: documentStatuses,
                  ),
                  const SizedBox(height: 16),
                  if (medium)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WorkflowChecklistPanel(
                            tasks: workflowTasks,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: RuleEnginePanel(
                            suggestions: ruleSuggestions,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    WorkflowChecklistPanel(tasks: workflowTasks),
                    const SizedBox(height: 16),
                    RuleEnginePanel(suggestions: ruleSuggestions),
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
                  const IntegrationStatusPanel(items: integrationStatuses),
                  const SizedBox(height: 16),
                  ReviewIssuesPanel(issues: reviewIssues),
                  const SizedBox(height: 16),
                  DocumentationPanel(selectedCase: selectedCase),
                  const SizedBox(height: 16),
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
    final stages = reportStagesForCase(selectedCase);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          eyebrow: 'Dokumentasjon',
          title: 'Rapportering, revisjonsspor og oppf\u00f8lging',
          detail: 'G\u00e5 fra intern vurdering til klargjort rapportutkast og videre oppf\u00f8lging i samme modul.',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1280
                ? 4
                : constraints.maxWidth >= 920
                    ? 2
                    : 1;
            final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
            final panels = [
              ReportSummary(escalated: escalated, closed: closed, total: cases.length),
              ReportingModulePanel(selectedCase: selectedCase, stages: stages),
              ReportDraftPanel(selectedCase: selectedCase),
              const AuditTrailPanel(),
            ];

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: panels.map((panel) => SizedBox(width: width, child: panel)).toList(),
            );
          },
        ),
      ],
    );
  }
}
