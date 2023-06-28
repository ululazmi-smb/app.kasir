import 'package:flutter/material.dart';
import 'package:tugas_kelompok_new/models/menu.dart';

class DetailScreen extends StatelessWidget {
  final Menu menu;

  DetailScreen({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'http://192.168.100.12/app.kasir/'+menu.image,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16.0),
            Text(
              'Menu: ${menu.title}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description: ${menu.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: \$${menu.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Tambah ke Keranjang'),
              onPressed: () {
                // Add your logic to add menu to cart here
                String menuTitle = menu.title;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Menu $menuTitle telah ditambahkan ke keranjang.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
