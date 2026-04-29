import 'package:flutter/material.dart';

import '../../../models/app_section.dart';
import '../../../theme/app_colors.dart';

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
          ...AppSection.values.map(
            (item) => NavButton(section: item, active: item == section, onTap: onChanged),
          ),
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
                LinearProgressIndicator(
                  value: 0.94,
                  color: Color(0xFF62B7A9),
                  backgroundColor: Color(0xFF494139),
                ),
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
                    labelStyle: TextStyle(
                      color: active ? AppColors.ink : Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
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
