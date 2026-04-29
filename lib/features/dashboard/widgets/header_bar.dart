import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import 'shared.dart';

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
            Text(
              'Operativ oversikt',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.1),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 12), search],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [title, search],
        );
      },
    );
  }
}
