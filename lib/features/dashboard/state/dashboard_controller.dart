import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../data/demo_data.dart';
import '../../../models/aml_case.dart';
import '../../../models/app_section.dart';

class DashboardController extends ChangeNotifier {
  AppSection _section = AppSection.overview;
  List<AmlCase> _cases = initialCases;
  String _selectedCaseId = initialCases.first.id;
  String _alertFilter = 'Alle';
  String _chartRange = '24 t';
  String _query = '';
  String _activeWorkflowId = workflowActions.first.id;
  int _activeAlerts = 184;
  String _activeDelta = '+14';

  AppSection get section => _section;
  List<AmlCase> get cases => _cases;
  String get alertFilter => _alertFilter;
  String get chartRange => _chartRange;
  String get query => _query;
  String get activeWorkflowId => _activeWorkflowId;
  int get activeAlerts => _activeAlerts;
  String get activeDelta => _activeDelta;

  AmlCase get selectedCase => _cases.firstWhere((item) => item.id == _selectedCaseId);

  List<AmlCase> get filteredCases {
    final normalizedQuery = _query.trim().toLowerCase();
    return _cases.where((item) {
      final matchesFilter =
          _alertFilter == 'Alle' || item.category == _alertFilter || item.status == _alertFilter;
      final searchable = [
        item.id,
        item.customer,
        item.signal,
        item.amount,
        item.status,
        item.owner,
        item.country,
      ].join(' ').toLowerCase();
      return matchesFilter && searchable.contains(normalizedQuery);
    }).toList();
  }

  void selectSection(AppSection section) {
    _section = section;
    notifyListeners();
  }

  void selectCase(String id) {
    _selectedCaseId = id;
    notifyListeners();
  }

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void updateAlertFilter(String value) {
    _alertFilter = value;
    notifyListeners();
  }

  void updateChartRange(String value) {
    _chartRange = value;
    notifyListeners();
  }

  void selectWorkflow(String workflowId) {
    _activeWorkflowId = workflowId;
    notifyListeners();
  }

  void escalateSelectedCase() => _setCaseStatus('Eskalert', 'review');

  void clearSelectedCaseRisk() => _setCaseStatus('Lavere risiko', 'closed');

  void assignSelectedCase(String owner) {
    _cases = _cases.map((item) {
      if (item.id != _selectedCaseId) {
        return item;
      }
      return item.copyWith(owner: owner, status: 'Vurderes', statusTone: 'review');
    }).toList();
    notifyListeners();
  }

  void _setCaseStatus(String status, String tone) {
    _cases = _cases.map((item) {
      if (item.id != _selectedCaseId) {
        return item;
      }
      return item.copyWith(status: status, statusTone: tone);
    }).toList();

    if (status == 'Lavere risiko') {
      _activeAlerts = math.max(_activeAlerts - 1, 0).toInt();
      _activeDelta = '+13';
    }

    notifyListeners();
  }
}
