import 'package:flutter/material.dart';

enum AppSection {
  overview('Arbeidsflyt', Icons.playlist_add_check_circle_rounded),
  alerts('Varsler', Icons.security_rounded),
  customers('Kunder', Icons.person_search_rounded),
  transactions('Transaksjoner', Icons.sync_alt_rounded),
  reports('Rapporter', Icons.description_rounded);

  const AppSection(this.label, this.icon);

  final String label;
  final IconData icon;
}
