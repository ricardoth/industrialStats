// ignore: camel_case_types
class DTO_TransactionType {
  String transactionNumber;
  String transactionSeverity;
  String transactionState;
  String transactionProcedure;
  String transactionLine;
  String transactionMessage;

  DTO_TransactionType(
      {this.transactionNumber,
      this.transactionSeverity,
      this.transactionState,
      this.transactionProcedure,
      this.transactionLine,
      this.transactionMessage});

  factory DTO_TransactionType.fromJson(Map<String, dynamic> json) {
    return DTO_TransactionType(
      transactionLine: json['transactionLine'],
      transactionMessage: json['transactionMessage'],
      transactionNumber: json['transactionNumber'],
      transactionProcedure: json['transactionProcedure'],
      transactionSeverity: json['transactionSeverity'],
      transactionState: json['transactionState'],
    );
  }
}
