import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensetrackingapp/pages/Profile.dart';
import 'package:expensetrackingapp/services/support_widget.dart';
import 'package:expensetrackingapp/services/SharedPreferenceHelper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "";
  double totalIncome = 0;
  double totalExpense = 0;
  String? userId;

  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    userId = await SharedPreferenceHelper().getUserId();

    if (userId == null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        await SharedPreferenceHelper().saveUserId(userId!);
      }
    }

    if (userId != null) {
      fetchUserData();
      fetchIncomeAndExpense();
      fetchRecentTransactions();
    }
  }

  Future<void> fetchUserData() async {
    if (userId == null) return;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc.get("Name") ?? "User";
      });
    }
  }

  Future<void> fetchIncomeAndExpense() async {
    if (userId == null) return;

    double income = 0;
    double expense = 0;

    QuerySnapshot incomeSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Income")
        .get();

    for (var doc in incomeSnap.docs) {
      income += (doc["amount"] ?? 0).toDouble();
    }

    QuerySnapshot expenseSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Expense")
        .get();

    for (var doc in expenseSnap.docs) {
      expense += (doc["amount"] ?? 0).toDouble();
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  Future<void> fetchRecentTransactions() async {
    if (userId == null) return;

    List<Map<String, dynamic>> transactions = [];

    QuerySnapshot expenseSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Expense")
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get();

    for (var doc in expenseSnap.docs) {
      transactions.add({
        "type": "Expense",
        "amount": doc["amount"],
        "category": doc["category"],
        "date": doc["date"],
      });
    }

    QuerySnapshot incomeSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Income")
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get();

    for (var doc in incomeSnap.docs) {
      transactions.add({
        "type": "Income",
        "amount": doc["amount"],
        "category": "Income",
        "date": doc["date"],
      });
    }

    setState(() {
      recentTransactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    double balance = totalIncome - totalExpense;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          userName,
                          style: AppWidget.headlineTextStyle(22.0),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(
                          'images/boy1.jpg',
                          height: 50.0,
                          width: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30.0),

                // Balance Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          "Balance",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "\$${balance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Income & Expense Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.green[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.arrow_downward,
                                  color: Colors.green, size: 30),
                              const SizedBox(height: 10),
                              const Text("Income",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                "\$${totalIncome.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        color: Colors.red[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.arrow_upward,
                                  color: Colors.red, size: 30),
                              const SizedBox(height: 10),
                              const Text("Expense",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                "\$${totalExpense.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Recent Transactions
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      var tx = recentTransactions[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            tx["type"] == "Income"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: tx["type"] == "Income"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                              "${tx["type"]}: \$${tx["amount"].toStringAsFixed(2)}"),
                          subtitle: Text("${tx["category"]} • ${tx["date"]}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
