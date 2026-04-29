class TransactionEvent {
  const TransactionEvent({
    required this.caseId,
    required this.time,
    required this.customer,
    required this.counterparty,
    required this.country,
    required this.amount,
    required this.scenario,
    required this.risk,
    required this.tone,
  });

  final String caseId;
  final String time;
  final String customer;
  final String counterparty;
  final String country;
  final String amount;
  final String scenario;
  final int risk;
  final String tone;
}
