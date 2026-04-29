import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/demo_data.dart';
import '../../../models/aml_case.dart';
import '../../../models/aml_customer.dart';
import '../../../models/metric.dart';
import '../../../theme/app_colors.dart';
import '../dashboard_utils.dart';
import 'painters.dart';
import 'shared.dart';

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
                      Flexible(
                        child: Text(metric.label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ),
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
            trailing: SegmentedButtons(
              values: const ['24 t', '7 d', '30 d'],
              selected: range,
              onChanged: onRangeChanged,
            ),
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
    const columns = ['Ny', 'Vurderes', 'Dokument', 'Eskalert', 'Lavere risiko'];

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
          ChecklistRow(
            label: 'Reell eier: ${selectedCase.beneficialOwner}',
            checked: selectedCase.beneficialOwnerOk,
          ),
          ChecklistRow(label: 'Eskalert til MLRO', checked: selectedCase.status == 'Eskalert'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onEscalate,
                icon: const Icon(Icons.priority_high_rounded),
                label: const Text('Eskaler'),
              ),
              OutlinedButton.icon(
                onPressed: onClearRisk,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Lavere risiko'),
              ),
              PopupMenuButton<String>(
                tooltip: 'Tildel analytiker',
                onSelected: onAssign,
                itemBuilder: (context) => analysts
                    .map((owner) => PopupMenuItem(value: owner, child: Text(owner)))
                    .toList(),
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
              Expanded(
                child: Text(customer.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ),
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
