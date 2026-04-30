import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../dashboard_utils.dart';

class SegmentedButtons extends StatelessWidget {
  const SegmentedButtons({
    required this.values,
    required this.selected,
    required this.onChanged,
    super.key,
  });

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
          labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.muted,
            fontWeight: FontWeight.w800,
          ),
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
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
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
      decoration: BoxDecoration(
        color: color.withAlpha(41),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900),
      ),
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

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.detail,
    this.trailing,
    super.key,
  });

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
          ?trailing,
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
        ?trailing,
      ],
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    super.key,
  });

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
        boxShadow: const [
          BoxShadow(color: Color(0x14231F19), blurRadius: 35, offset: Offset(0, 14)),
        ],
      ),
      child: child,
    );
  }
}
