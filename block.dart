import 'dart:collection';
import 'transaction.dart';

class Block {
  final int index;
  final int timestamp;
  final List<Transaction> transactions;
  int proof;
  final String prevHash;
  Block(
      this.index, this.timestamp, this.transactions, this.proof, this.prevHash);

  Map<String, dynamic> toJson() {
    // keys must be ordered for consistent hashing
    var m = new LinkedHashMap<String, dynamic>();

    m['index'] = index;
    m['timestamp'] = timestamp;
    m['transactions'] = transactions.map((t) => t.toJson()).toList();
    m['proof'] = proof;
    m['prevHash'] = prevHash;
    return m;
  }
}
