import 'package:blockchain.dart';
import 'package:uuid/uuid.dart';

class Miner {
  final Blockchain blockchain;
  final String nodeId;

  Miner(this.blockchain) : nodeId = new Uuid().v4();

  MineResult mine() {
    var lastBlock = blockchain.lastBlock;
    var lastProof = lastBlock.proof;
    var proof = blockchain.proofOfWork(lastProof);
    // Proof found - receive award for finding the proof
    blockchain.newTransaction("0", nodeId, 1.0);

    // Forge the new Block by adding it to the chain
    var prevHash = blockchain.hash(lastBlock);
    var block = blockchain.newBlock(proof, prevHash);
    return new MineResult(
        "New Block Forged", block.index, block.transactions, proof, prevHash);
  }
}

class MineResult {
  final String message;
  final int blockIndex;
  final List transactions;
  final int proof;
  final String prevHash;
  MineResult(this.message, this.blockIndex, this.transactions, this.proof,
      this.prevHash);
}
