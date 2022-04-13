class Transaction {
  String sender;
  String recipient;
  double amount;
  int proof;
  String prevHash;

  Transaction(this.sender, this.recipient, this.amount);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "sender": sender,
      "recipient": recipient,
      "amount": amount,
      "proof": proof,
      "prevHash": prevHash,
    };
  }
}
