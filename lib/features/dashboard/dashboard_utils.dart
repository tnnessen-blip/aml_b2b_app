import 'package:flutter/material.dart';

import '../../models/aml_case.dart';
import '../../models/aml_customer.dart';
import '../../theme/app_colors.dart';

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
