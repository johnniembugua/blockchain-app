
---
layout: engineering-education
status: publish
published: true
url: /developing-simple-blockchain-app-in-flutter/
title: How to Develop a Simple Blockchain App in Flutter
description: This article will help the reader understand how to create a simple blockchain application in Flutter.
author: johnnie-mbugua
date: 2022-01-07T00:00:00-12:48
topics: [Languages]
excerpt_separator: <!--more-->
images:

  - url: /engineering-education/developing-simple-blockchain-app-in-flutter/hero.jpg
    alt: Developing Simple Blockchain App in Flutter Hero Image
---
Flutter is used to create cross-platform applications that run on iOS, Android, and on the web. It is an advanced framework that supports fast prototyping and high perfomance.
<!--more--> 
Flutter utilizes Google's Skia library to draw UI widgets on the screen. In this tutorial, we will be using the `blockchain` library to create a simple Flutter application.

### Prerequisites
To follow along, you need to:
- Have Visual Studio Code installed.
- Be familiar with the Flutter framework and Dart language.
- Have some knowledge about blockchain technology.

### Creating a blockchain Flutter application
To get started, we need to first install the `Flutter SDK`. You can find the installation instructions [here](https://flutter.dev/).

Once you have installed the Flutter SDK, you can create a `new project` by running the following command in your terminal:

```bash
flutter create my-blockchain-app
```

Now that our project is created, let's open it in a code editor.  I will be using Visual Studio Code for this tutorial.

### Creating Blocks
The blocks are the main nodes of the blockchain.Create a new file in the lib folder or the folder of your choice according to your project set up.Then Write this code:
```dart
import 'dart:collection';
import 'transaction.dart';

class Block {
  final int index;
  final int timestamp;
  final List<Transaction> transactions;
  int proof;
  final String prevHash;
  Block(this.index, this.timestamp, this.transactions, this.proof, this.prevHash);

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
```
The block contain various data being index which tell the number of the block , Timestap used to sign every block, List of the transaction that took place between that time(timestamps), Previous hash that link the current block to the previous block and proof that its valid.
### Creating Transaction Class
Create a new file called transaction or optionally you can create this class in our previous file the block class .This Trasaction class is responsible for all the records of any transfer the assest from the sender to reciever amount, previous hash and also some proof of the transaction. 
```dart
class Transaction {
  String sender;
  String recipient;
  double amount;
  int proof;
  String prevHash;

  Transaction(this.sender, this.recipient, this.amount);

  Map<String, dynamic> toJson() {
    return <String,dynamic>{
      "sender": sender,
      "recipient": recipient,
      "amount": amount,
      "proof": proof,
      "prevHash": prevHash,
    };
  }
}
```
This Class contains various set of data like the Sender of the assets, the reciever or recipeint of the assets,amount is how much or how many assests are being sent,proof of the transaction to be valid, previoushash of the previous block for refference. 
### Creating Our Blockchain.
This is the main class of our logic. It holds the most important part of this application.It has various methods defined in it.Remember to first import the necessary files we created above.
```dart
import 'dart:convert';
import 'transaction.dart';
import 'block.dart';
import 'package:crypto/crypto.dart' as crypto;
import "package:hex/hex.dart";

class Blockchain {
  final List<Block> _chain;
  final List<Transaction> _currentTransactions;

  Blockchain()
      : _chain = [],
        _currentTransactions = [] {
    // create genesis block
    newBlock(100, "1");
  }

  Block newBlock(int proof, String previousHash) {
    if (previousHash == null) {
      previousHash = hash(_chain.last);
    }
    var block = new Block(
      _chain.length,
      new DateTime.now().millisecondsSinceEpoch,
      _currentTransactions,
      proof,
      previousHash,
    );

    _currentTransactions.clear(); // = [] ?

    _chain.add(block);

    return block;
  }

  int newTransaction(String sender, String recipient, double amount) {
    _currentTransactions.add(new Transaction(sender, recipient, amount));
    return lastBlock.index + 1;
  }

  Block get lastBlock {
    return _chain.last;
  }

  String hash(Block block) {
    var blockStr = JSON.encode(block.toJson());
    var bytes = UTF8.encode(blockStr);
    var converted = crypto.sha256.convert(bytes).bytes;
    return HEX.encode(converted);
  }

  int proofOfWork(int lastProof) {
    var proof = 0;
    while (!validProof(lastProof, proof)) {
      proof++;
    }
    return proof;
  }

  bool validProof(int lastProof, int proof) {
    var guess = UTF8.encode("${lastProof}${proof}");
    var guessHash = crypto.sha256.convert(guess).bytes;
    return HEX.encode(guessHash).substring(0, 4) == "0000";
  }
}
```
We begun by creating Blockchain class that will hold all blocks linked up together. Our first block is the genesis block it has no prev hash.After the first block all blocks mined after it have previous hash to connected the preciding blocks.Hash is a combination of characters that is unique to every block generated in the process of mining which for this case we are using proof of work.All nodes compete to generate the hash  and the broadcasts to the other nodes in the network but for our case its just one device generating the hash.
### Creating the Our blockachain miner
The miner class is responsible of generating new assets or tokens. In most cases miners are rewarded for validating the transactions.The rewards vary from time to time depending on the blockchain. Mining helps to generate new blocks if mining stops the blockchain reaches an end. For our case our miner links the last block to the new mined block using the hash. 
```dart
import 'blockchain.dart';
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
```
Our MineResult class stores data of the any message linked to our transactions.Blockindex to identify the block number, transactions to be stored in the block, prev hash to link to the block being mined to the last block mined.


Thats how you create a simple blockchain using flutter.Lets me share some more knowledge on how to go about managing blockchaindatabase.

### Addtional Information

###  Managing our blockchain database
Let's create a class called `BlockchainDatabaseManager`. We will use this class as a wrapper for managing transactions and blocks.

We want to create new blockchains by instantiating `BlockchainDatabaseManager`. We need to add the following code to our `main()` function:

```dart
final BlockchainDatabaseManager _blockchainDatabase = new BlockchainDatabaseManager();
```

Now if we run our application, we should see the following message:

This is because we have not created any blockchains yet. We can do this by running the following code in our `main()` function:

```dart
_blockchainDatabase.create();
```

We now have one blockchain. However, we want to add transactions or blocks. 

To do this, let's create an interface called `IBlockchain` that will allow our database manager class to interact with the blockchain.

```dart
interface IBlockchain {

}
```

By implementing this interface in our BlockchainDatabaseManager , we can use our blockchain database manager class to interact with any blockchain that implements this interface.

Now let's add some methods to our `BlockchainDatabaseManager` class. These methods will allow us to add `transactions` and `blocks` to our blockchain.

```dart
class BlockchainDatabaseManager implements IBlockchain {

void addTransaction(Transaction transaction) { }

void addBlock(List<Transaction> transactions, int blockHeight) { }
```

Now if we run our application, we should be able to add `transactions` and `blocks` by running the following lines of code in our `main()` function:

```dart
_blockchainDatabase.transactions.add(transaction);  _blockchainDatabase.blocks.add(block);
```

We can also get `transactions` and `blocks` from our blockchain using the following methods:

```dart
List<Transaction> getTransactions();

int getBlockHeight();
```

We should also add some helper functions to make these calls easier. Add the following code to your `BlockchainDatabaseManager` class:

```dart
Transaction getTransaction(int transactionHash);
void getTransaction(Transaction transaction) { }
int getBlockHeight(int blockHash);
void getBlockHeight(int blockHeight)  { }
```

We can now access transactions and blocks from our blockchain database by running the following code in our `main()` function:

```dart
_blockchainDatabase.transactions.get(transactionHash);  _blockchainDatabase.getBlockHeight(blockHash);
```

We now have a fully functional blockchain database manager with transactions and blocks. However, we currently do not save this data. We could, therefore, lose it when we restart our application. 

To solve this problem, let's create a class called `Blockchain`. This class will be in charge of saving our blockchain database.

```dart
class Blockchain {
int _blockchainHeight = 0;
final BlockchainDatabaseManager _blockchainDatabase = new BlockchainDatabaseManager();
addBlock(List<Transaction> transactions, int blockHeight) { }
addTransaction(Transaction transaction) { }
getBlockHeight() { }
getTransactions() {};
save() {}
   void save(String filename) {
        File _file = new File(_fileName);
          if (!_file.exists()) {
           try {
            _file.createNewFile();
             } catch (IOException e) {
             print('Error creating file: $e');
          return;
```

Now we can simply use the `Blockchain` class to save our blockchain database by running the following code in our `main()` function:

```dart
Blockchain blockchain = new Blockchain();
blockchain.addBlock(transaction);
blockchain.save('filename');
```

We can now add new blocks and transactions to our blockchain and save them to a file. 

However, this data needs to be synchronized across different devices so that we all see the same results. To do this, we will need to use a blockchain network.

A blockchain network is a group of devices that are all connected to each other and share the same database. 

When a new block or transaction is added to the blockchain, it is synchronized across all devices in the network. 

This way, everyone sees the same result when they run the application on their devices. To connect multiple devices together to form a blockchain network, we will use the `MqttClient` class.

Let's add some functionality to our new `Blockchain`class by including an instance of the `MqttClient` class.  

We want this client to run on a different `thread` so let's make it an `AsyncTask` using the `async` keyword in front of the class declaration. 

It should be a private member variable so that other classes can't access it.

```dart
class Blockchain {
    MqttClient _mqttClient = new MqttClient();

AsyncTask<Void, Void, String>
 asyncTask = new AsyncTask<Void, Void, String>() {

 @Override  protected String doInBackground(Void... params) {

return null;        }

};
```

We can now run the `MqttClient` instance on a different thread. However, if we don't register it, we will not receive any messages. 

Let's add an instance of the `MqttMessageHandler` class to our application and register our `_mqttClient` instance.

```dart
class Blockchain {

    MqttClient _mqttClient = new MqttClient();

    AsyncTask<Void, Void, String> asyncTask = new AsyncTask<Void, Void, String>() {

            @Override  protected String doInBackground(Void... params) {

    return null;         }

    };

MqttMessageHandler messageHandler = new MqttMessageHandler();

_mqttClient.setHandler(messageHandler);
```

Now our `_mqttClient` instance will receive messages from the blockchain network. Finally, let's add some code to save the blockchain data to a file:

```dart
class Blockchain {

    MqttClient _mqttClient = new MqttClient();

AsyncTask<Void, Void, String> asyncTask = new AsyncTask<Void, Void, String>() {

 @Override  protected String doInBackground(Void... params) {
return null;         }
@Override  protected void onPostExecute(String result) {
getBlockHeight();
Blockchain network = new Blockchain();
   _mqttClient.connect("myDevices");
```

Now we can build our blockchain network by adding devices to it one at a time after they have registered with the same `MQTT` broker. 

Fortunately, Flutter provides us with an easy way to do this. We only need to add a button and call the `addDevice()` function when it is clicked.

```dart
void main() {
    runApp(new MyApp());
}

class MyApp extends StatelessWidget {
    Widget build(BuildContext context) {
        return new MaterialApp(
        home: new Scaffold(
        appBar: new AppBar(
        title: new Text("My Blockchain"),
        ),
        body: new HomePage(), );
            Button(
                onClick: () {
                network.addDevice();
        });
    } 
}
```

Notice that we are connecting to `my Devices`, which is the name of my` MQTT` broker. You will need to change this to match the name of your broker. 

When you run the application on different devices, they will all be connected to the same blockchain network and thus, share the blockchain data.

### Conclusion
Congratulations! You have now created a Flutter application that uses a Dart blockchain.

This is just a simple blockchain application consisting of several devices. Each transaction is broadcasted to all the other devices

You can access the full code from [this GitHub repository](https://github.com/johnniembugua/blockchain-app).

Happy coding!

---
Peer Review Contributions by: [Daniel Katungi](/engineering-education/authors/daniel-katungi/)