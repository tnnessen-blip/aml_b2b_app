class AmlCustomer {
  const AmlCustomer({
    required this.name,
    required this.primaryCaseId,
    required this.segment,
    required this.country,
    required this.owner,
    required this.risk,
    required this.riskTone,
    required this.kycLevel,
    required this.ownerVerified,
  });

  final String name;
  final String primaryCaseId;
  final String segment;
  final String country;
  final String owner;
  final int risk;
  final String riskTone;
  final String kycLevel;
  final bool ownerVerified;
}
