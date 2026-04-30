import 'package:flutter/material.dart';

class WorkflowAction {
  const WorkflowAction({
    required this.id,
    required this.title,
    required this.detail,
    required this.badge,
    required this.icon,
  });

  final String id;
  final String title;
  final String detail;
  final String badge;
  final IconData icon;
}

class WorkflowTask {
  const WorkflowTask({
    required this.title,
    required this.detail,
    required this.state,
    required this.automation,
    required this.tone,
  });

  final String title;
  final String detail;
  final String state;
  final String automation;
  final String tone;
}

class IntegrationStatus {
  const IntegrationStatus({
    required this.system,
    required this.state,
    required this.detail,
    required this.access,
    required this.tone,
  });

  final String system;
  final String state;
  final String detail;
  final String access;
  final String tone;
}

class RegistryComparison {
  const RegistryComparison({
    required this.label,
    required this.registeredValue,
    required this.amlValue,
    required this.detail,
    required this.match,
  });

  final String label;
  final String registeredValue;
  final String amlValue;
  final String detail;
  final bool match;
}

class RuleSuggestion {
  const RuleSuggestion({
    required this.title,
    required this.detail,
    required this.recommendation,
    required this.tone,
  });

  final String title;
  final String detail;
  final String recommendation;
  final String tone;
}

class DocumentStatus {
  const DocumentStatus({
    required this.label,
    required this.state,
    required this.source,
    required this.tone,
  });

  final String label;
  final String state;
  final String source;
  final String tone;
}

class ReviewIssue {
  const ReviewIssue({
    required this.title,
    required this.detail,
    required this.source,
    required this.tone,
  });

  final String title;
  final String detail;
  final String source;
  final String tone;
}

class ReportStage {
  const ReportStage({
    required this.title,
    required this.detail,
    required this.complete,
  });

  final String title;
  final String detail;
  final bool complete;
}
