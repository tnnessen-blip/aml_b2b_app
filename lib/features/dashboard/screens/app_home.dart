import 'package:flutter/material.dart';

import '../../../data/demo_data.dart';
import '../../../models/aml_case.dart';
import '../../../models/app_section.dart';
import '../dashboard_utils.dart';
import '../state/dashboard_controller.dart';
import '../widgets/header_bar.dart';
import '../widgets/navigation.dart';
import 'views.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final _searchController = TextEditingController();
  final _controller = DashboardController();

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final content = AppContent(
          section: _controller.section,
          cases: _controller.cases,
          filteredCases: _controller.filteredCases,
          selectedCase: _controller.selectedCase,
          alertFilter: _controller.alertFilter,
          chartRange: _controller.chartRange,
          activeWorkflowId: _controller.activeWorkflowId,
          activeAlerts: _controller.activeAlerts,
          activeDelta: _controller.activeDelta,
          searchController: _searchController,
          onSearchChanged: _controller.updateQuery,
          onAlertFilterChanged: _controller.updateAlertFilter,
          onChartRangeChanged: _controller.updateChartRange,
          onWorkflowSelected: _controller.selectWorkflow,
          onSelectCase: _controller.selectCase,
          onEscalate: _controller.escalateSelectedCase,
          onClearRisk: _controller.clearSelectedCaseRisk,
          onAssign: _controller.assignSelectedCase,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1120;
            return Scaffold(
              body: SafeArea(
                child: wide
                    ? Row(
                        children: [
                          SideNavigation(
                            section: _controller.section,
                            onChanged: _controller.selectSection,
                          ),
                          Expanded(child: content),
                        ],
                      )
                    : Column(
                        children: [
                          MobileNavigation(
                            section: _controller.section,
                            onChanged: _controller.selectSection,
                          ),
                          Expanded(child: content),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({
    required this.section,
    required this.cases,
    required this.filteredCases,
    required this.selectedCase,
    required this.alertFilter,
    required this.chartRange,
    required this.activeWorkflowId,
    required this.activeAlerts,
    required this.activeDelta,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAlertFilterChanged,
    required this.onChartRangeChanged,
    required this.onWorkflowSelected,
    required this.onSelectCase,
    required this.onEscalate,
    required this.onClearRisk,
    required this.onAssign,
    super.key,
  });

  final AppSection section;
  final List<AmlCase> cases;
  final List<AmlCase> filteredCases;
  final AmlCase selectedCase;
  final String alertFilter;
  final String chartRange;
  final String activeWorkflowId;
  final int activeAlerts;
  final String activeDelta;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onAlertFilterChanged;
  final ValueChanged<String> onChartRangeChanged;
  final ValueChanged<String> onWorkflowSelected;
  final ValueChanged<String> onSelectCase;
  final VoidCallback onEscalate;
  final VoidCallback onClearRisk;
  final ValueChanged<String> onAssign;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderBar(controller: searchController, onChanged: onSearchChanged),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (section) {
              AppSection.overview => OverviewView(
                  key: const ValueKey('overview'),
                  cases: cases,
                  filteredCases: filteredCases,
                  selectedCase: selectedCase,
                  activeAlerts: activeAlerts,
                  activeDelta: activeDelta,
                  alertFilter: alertFilter,
                  chartRange: chartRange,
                  activeWorkflowId: activeWorkflowId,
                  onAlertFilterChanged: onAlertFilterChanged,
                  onChartRangeChanged: onChartRangeChanged,
                  onWorkflowSelected: onWorkflowSelected,
                  onSelectCase: onSelectCase,
                  onEscalate: onEscalate,
                  onClearRisk: onClearRisk,
                  onAssign: onAssign,
                ),
              AppSection.alerts => AlertsView(
                  key: const ValueKey('alerts'),
                  cases: filteredCases,
                  selectedCase: selectedCase,
                  filter: alertFilter,
                  onFilterChanged: onAlertFilterChanged,
                  onSelectCase: onSelectCase,
                  onEscalate: onEscalate,
                  onClearRisk: onClearRisk,
                  onAssign: onAssign,
                ),
              AppSection.customers => CustomersView(
                  key: const ValueKey('customers'),
                  customers: customersFromCases(cases),
                  onOpenCustomer: onSelectCase,
                ),
              AppSection.transactions => TransactionsView(
                  key: const ValueKey('transactions'),
                  transactions: transactionEvents,
                  onSelectCase: onSelectCase,
                ),
              AppSection.reports => ReportsView(
                  key: const ValueKey('reports'),
                  cases: cases,
                  selectedCase: selectedCase,
                ),
            },
          ),
        ],
      ),
    );
  }
}
