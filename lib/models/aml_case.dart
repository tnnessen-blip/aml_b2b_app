class AmlCase {
  const AmlCase({
    required this.id,
    required this.customer,
    required this.segment,
    required this.signal,
    required this.summary,
    required this.amount,
    required this.risk,
    required this.riskTone,
    required this.status,
    required this.statusTone,
    required this.category,
    required this.date,
    required this.due,
    required this.owner,
    required this.country,
    required this.kycLevel,
    required this.beneficialOwner,
    required this.beneficialOwnerOk,
    required this.note,
  });

  final String id;
  final String customer;
  final String segment;
  final String signal;
  final String summary;
  final String amount;
  final int risk;
  final String riskTone;
  final String status;
  final String statusTone;
  final String category;
  final String date;
  final String due;
  final String owner;
  final String country;
  final String kycLevel;
  final String beneficialOwner;
  final bool beneficialOwnerOk;
  final String note;

  AmlCase copyWith({String? status, String? statusTone, String? owner}) {
    return AmlCase(
      id: id,
      customer: customer,
      segment: segment,
      signal: signal,
      summary: summary,
      amount: amount,
      risk: risk,
      riskTone: riskTone,
      status: status ?? this.status,
      statusTone: statusTone ?? this.statusTone,
      category: category,
      date: date,
      due: due,
      owner: owner ?? this.owner,
      country: country,
      kycLevel: kycLevel,
      beneficialOwner: beneficialOwner,
      beneficialOwnerOk: beneficialOwnerOk,
      note: note,
    );
  }
}
