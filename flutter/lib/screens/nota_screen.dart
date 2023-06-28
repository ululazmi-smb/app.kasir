import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_kelompok_new/models/menu.dart';

class NotaScreen extends StatelessWidget {
  final double totalBill;
  final double paidAmount;
  final String queueNumber;
  final List<Menu> cartItems;

  NotaScreen({
    required this.totalBill,
    required this.paidAmount,
    required this.queueNumber,
    required this.cartItems,
  });

  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota'),
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
