import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_kelompok_new/screens/TransactionDetail.dart';
class TransactionReportScreen extends StatefulWidget {
  @override
  _TransactionReportScreenState createState() => _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  List<Transaction> transactions = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final List<Transaction> fetchedTransactions = await getTransactionsFromAPI();

    setState(() {
      transactions = fetchedTransactions;
    });
  }

  Future<List<Transaction>> getTransactionsFromAPI() async {
    final url = Uri.parse('http://192.168.100.12/app.kasir/api/menu/transactions'); // Replace with your API endpoint URL

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          return Transaction(
            id: item['id'],
            amount: item['amount'].toDouble(),
            date: DateTime.parse(item['date']),
          );
        }).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return []; // Return an empty list if there's an error
  }

  void sortTransactionsByDate() {
    setState(() {
      transactions.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  void filterTransactionsByDate(DateTime selectedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      transactions = transactions.where((transaction) {
        return transaction.date.year == selectedDate.year &&
            transaction.date.month == selectedDate.month &&
            transaction.date.day == selectedDate.day;
      }).toList();
    });
  }

  void resetFilter() {
    setState(() {
      selectedDate = null;
      fetchTransactions();
    });
  }

  void navigateToTransactionDetail(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(transactionId: transaction.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  filterTransactionsByDate(selectedDate);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetFilter,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          return GestureDetector(
            onTap: () => navigateToTransactionDetail(transaction),
            child: ListTile(
              leading: Text('ID: ${transaction.id}'),
              title: Text('Amount: Rp. ${transaction.amount} ,-'),
              subtitle: Text('Date: ${transaction.date.toString()}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sort),
        onPressed: sortTransactionsByDate,
      ),
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  Transaction({
    required this.id,
    required this.amount,
    required this.date,
  });
}