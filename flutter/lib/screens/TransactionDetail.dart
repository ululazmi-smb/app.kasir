import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;

  TransactionDetailScreen({required this.transactionId});

  @override
  _TransactionDetailScreenState createState() => _TransactionDetailScreenState();
}
class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  int totalBill = 0;
  int paidAmount = 0;
  String queueNumber = '';
  List<Menu> cartItems = [];

  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    final url = Uri.parse('http://192.168.100.12/app.kasir/api/menu/transactions/${widget.transactionId}'); // Ganti dengan URL endpoint API Anda

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          queueNumber = data['id'];
          totalBill = data['amount'];
          paidAmount = data['paidAmount'];
          cartItems = List<Menu>.from(data['detail'].map((item) {
            return Menu(
              title: item['title'],
              price: item['price'],
              quantity: item['quantity'],
            );
          }));
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Queue Number: $queueNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text('Price: ${formatCurrency.format(item.price)}'),
                    trailing: Text('Quantity: ${item.quantity}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Bill: ${formatCurrency.format(totalBill)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Paid Amount: ${formatCurrency.format(paidAmount)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Change: ${formatCurrency.format(paidAmount - totalBill)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Menu {
  final String title;
  final double price;
  final int quantity;

  Menu({
    required this.title,
    required this.price,
    required this.quantity,
  });
}
