import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_kelompok_new/models/menu.dart';
import 'package:tugas_kelompok_new/screens/nota_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Menu> cartItems;

  CartScreen({required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  double totalBill = 0;
  double paidAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalBill();
  }

  void calculateTotalBill() {
    totalBill = 0;
    for (var item in widget.cartItems) {
      totalBill += (item.price * item.quantity);
    }
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      calculateTotalBill();
    });
  }

  Future<void> sendOrderDataToAPI(List<Menu> cartItems) async {
    final url = 'http://192.168.100.12/app.kasir/api/menu/checkout'; // Ubah alamat URL server sesuai kebutuhan

    final List<Map<String, dynamic>> orderData = cartItems.map((item) {
      return {
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
      };
    }).toList();

    final data = jsonEncode({'order_items': orderData,'paid_amount': paidAmount});

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: data,
    );

    if (response.statusCode == 200) {
      // Berhasil mengirim data pesanan ke server
      final responseData = json.decode(response.body);

      final queueNumber = responseData['queue_number'];

      // Tampilkan halaman nota dengan data yang diterima
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotaScreen(
            totalBill: totalBill,
            paidAmount: paidAmount,
            queueNumber: queueNumber,
            cartItems: widget.cartItems,
          ),
        ),
      );
    } else {
      // Gagal mengirim data pesanan ke server, tampilkan pesan error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send order data. Please try again.'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void clearCart() {
    setState(() {
      widget.cartItems.clear();
      calculateTotalBill();
    });
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Bill: ${formatCurrency.format(totalBill)}'),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    paidAmount = double.tryParse(value) ?? 0;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Paid Amount',
                  prefixText: formatCurrency.currencySymbol,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                // Panggil fungsi untuk mengirim data pesanan ke server
                sendOrderDataToAPI(widget.cartItems);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      'http://192.168.100.12/app.kasir/' +
                          widget.cartItems[index].image,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(widget.cartItems[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Price: ${formatCurrency.format(widget.cartItems[index].price)}'),
                        Text(
                            'Quantity: ${widget.cartItems[index].quantity}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeFromCart(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Bill: ${formatCurrency.format(totalBill)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Process Order'),
            onPressed: () {
              showPaymentDialog(context);
            },
          ),
          ElevatedButton(
            child: Text('Hapus Bersih Keranjang'),
            onPressed: () {
              clearCart();
            },
          ),
        ],
      ),
    );
  }
}
