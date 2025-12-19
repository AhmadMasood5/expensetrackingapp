import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  static Future<void> addUserInfo(
      Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  static Future<void> addExpense(
      Map<String, dynamic> expenseData, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Expense")
        .add(expenseData);
  }

  static Future<void> addIncome(
      Map<String, dynamic> incomeData, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Income")
        .add(incomeData);
  }
}
