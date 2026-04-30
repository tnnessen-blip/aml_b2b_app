import 'package:flutter/material.dart';

import '../../../models/aml_case.dart';
import '../../../models/automation_models.dart';
import '../../../theme/app_colors.dart';
import 'shared.dart';

class WorkflowLauncherPanel extends StatelessWidget {
  const WorkflowLauncherPanel({
    required this.actions,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<WorkflowAction> actions;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(
            eyebrow: 'Startpunkt',
            title: 'Hva pr\u00f8ver du \u00e5 gj\u00f8re?',
          ),
          const SizedBox(height: 8),
          const Text(
            'Brukeren velger jobb, appen henter det som kan hentes og ber bare om det som mangler.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1120
                  ? 3
                  : constraints.maxWidth >= 760
                      ? 2
                      : 1;
              final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: actions.map((action) {
                  final active = action.id == selectedId;
                  return SizedBox(
                    width: width,
                    child: InkWell(
                      onTap: () => onSelected(action.id),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFFEEF8F5) : AppColors.surfaceStrong,
                          border: Border.all(
                            color: active ? const Color(0xFF9ECDC5) : AppColors.line,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: active ? AppColors.teal.withAlpha(28) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(action.icon, color: AppColors.tealDark),
                                ),
                                const Spacer(),
                                StatusPill(label: action.badge, tone: active ? 'normal' : 'watch'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(action.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text(action.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class WorkflowChecklistPanel extends StatelessWidget {
  const WorkflowChecklistPanel({required this.tasks, super.key});

  final List<WorkflowTask> tasks;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Kundetiltak', title: 'Steg for steg'),
          const SizedBox(height: 14),
          ...tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceStrong,
                      border: Border.all(color: AppColors.line),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 10),
                            StatusPill(label: task.state, tone: task.tone),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(task.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                        const SizedBox(height: 4),
                        Text(task.automation, style: const TextStyle(color: AppColors.tealDark, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class IntegrationStatusPanel extends StatelessWidget {
  const IntegrationStatusPanel({required this.items, super.key});

  final List<IntegrationStatus> items;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Integrasjoner', title: 'Autoritative kilder'),
          const SizedBox(height: 14),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceStrong,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(item.system, style: const TextStyle(fontWeight: FontWeight.w900)),
                        ),
                        StatusPill(label: item.state, tone: item.tone),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                    const SizedBox(height: 6),
                    Text(item.access, style: const TextStyle(color: AppColors.tealDark, fontSize: 12)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class CustomerCasePanel extends StatelessWidget {
  const CustomerCasePanel({
    required this.selectedCase,
    required this.comparisons,
    required this.documents,
    super.key,
  });

  final AmlCase selectedCase;
  final List<RegistryComparison> comparisons;
  final List<DocumentStatus> documents;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHeader(
            eyebrow: 'Kundesak',
            title: selectedCase.customer,
            trailing: StatusPill(label: '${selectedCase.risk}', tone: selectedCase.riskTone),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _KeyValue(label: 'Organisasjon', value: selectedCase.id),
              _KeyValue(label: 'Segment', value: selectedCase.segment),
              _KeyValue(label: 'Land / geografi', value: selectedCase.country),
              _KeyValue(label: 'Ansvarlig', value: selectedCase.owner),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Offentlig registrert vs AML-vurdering', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...comparisons.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceStrong,
                  border: Border.all(color: item.match ? AppColors.line : const Color(0xFFE5C3BE)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w800))),
                        StatusPill(label: item.match ? 'Samsvar' : 'Avvik', tone: item.match ? 'closed' : 'review'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Registrert: ${item.registeredValue}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('AML-vurdering: ${item.amlValue}', style: const TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 4),
                    Text(item.detail, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          const Text('Dokumentpakke bygges automatisk', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...documents.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.tone == 'closed' ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                    size: 18,
                    color: item.tone == 'closed' ? AppColors.green : AppColors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w700))),
                            StatusPill(label: item.state, tone: item.tone),
                          ],
                        ),
                        Text(item.source, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class RuleEnginePanel extends StatelessWidget {
  const RuleEnginePanel({required this.suggestions, super.key});

  final List<RuleSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Regelmotor', title: 'Anbefalt l\u00f8p'),
          const SizedBox(height: 14),
          ...suggestions.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceStrong,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900))),
                        StatusPill(label: item.recommendation, tone: item.tone),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ReviewIssuesPanel extends StatelessWidget {
  const ReviewIssuesPanel({required this.issues, super.key});

  final List<ReviewIssue> issues;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Avvik og mangler', title: 'Stopp f\u00f8r innsending'),
          const SizedBox(height: 14),
          ...issues.map((issue) {
            final color = switch (issue.tone) {
              'critical' => AppColors.red,
              'high' => AppColors.amber,
              _ => AppColors.teal,
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  border: Border.all(color: color.withAlpha(70)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline_rounded, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(issue.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(issue.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                          const SizedBox(height: 4),
                          Text(issue.source, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DocumentationPanel extends StatelessWidget {
  const DocumentationPanel({required this.selectedCase, super.key});

  final AmlCase selectedCase;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Dokumentasjon', title: 'Bygges mens saksbehandler jobber'),
          const SizedBox(height: 14),
          _EvidenceRow(
            label: 'Kontrollerte parter',
            value: '${selectedCase.customer}, representant og reelle rettighetshavere',
          ),
          _EvidenceRow(
            label: 'Hentede data',
            value: 'Virksomhetsdata, roller, geografi og registrerte rettighetshavere',
          ),
          _EvidenceRow(
            label: 'Mangler',
            value: selectedCase.beneficialOwnerOk ? 'Ingen kritiske mangler' : 'Eierskap krever manuell avklaring',
          ),
          _EvidenceRow(
            label: 'Risikovurdering',
            value: '${selectedCase.risk} / ${selectedCase.status}',
          ),
          _EvidenceRow(
            label: 'Begrunnelse',
            value: selectedCase.note,
          ),
        ],
      ),
    );
  }
}

class ReportingModulePanel extends StatelessWidget {
  const ReportingModulePanel({
    required this.selectedCase,
    required this.stages,
    super.key,
  });

  final AmlCase selectedCase;
  final List<ReportStage> stages;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(eyebrow: 'Rapportering og oppf\u00f8lging', title: 'Fra mistanke til rapportutkast'),
          const SizedBox(height: 12),
          Text(
            'Saksbehandler skal kunne g\u00e5 fra kundesak til intern vurdering og videre til klargjort rapportutkast i samme modul.',
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
          ...stages.map((stage) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    stage.complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: stage.complete ? AppColors.green : AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stage.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                        Text(stage.detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          StatusPill(
            label: selectedCase.status == 'Eskalert' ? 'Klar for MLRO-gate' : 'F\u00f8lg opp i kundesak',
            tone: selectedCase.status == 'Eskalert' ? 'critical' : 'review',
          ),
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _EvidenceRow extends StatelessWidget {
  const _EvidenceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(label, style: const TextStyle(color: AppColors.muted)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
