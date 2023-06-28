import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_kelompok_new/models/menu.dart';
import 'package:tugas_kelompok_new/screens/detail_screen.dart';
import 'package:tugas_kelompok_new/screens/cart_screen.dart';
import 'package:tugas_kelompok_new/screens/add_produk.dart';
import 'package:tugas_kelompok_new/screens/TransactionReportScreen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String limitString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }

  final List<Menu> menus = [];
  List<Menu> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final url = Uri.parse('http://192.168.100.12/app.kasir/api/Menu'); // Ganti URL_API dengan URL API yang sesuai
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Berhasil mendapatkan data dari API
        final List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          menus.clear();
          for (var item in data) {
            menus.add(
              Menu(
                id: item['id'],
                title: item['title'],
                description: item['description'],
                image: item['image'],
                price: int.parse(item['price']),
              ),
            );
          }
        });
      } else {
        // Gagal mendapatkan data dari API
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> refreshMenus() async {
    await fetchMenus();
  }

  Future<void> deleteMenu(String id) async {
    final url = Uri.parse('http://192.168.100.12/app.kasir/api/menu/delete/$id'); // Ganti URL_API dengan URL API yang sesuai
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        // Berhasil menghapus menu dari API
        print('Product with ID $id deleted successfully');
        fetchMenus(); // Refresh the menu list
      } else {
        // Gagal menghapus menu dari API
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String _selectedOption = 'Option 1';
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedOption = value;
              });

              // Navigasi ke halaman baru berdasarkan opsi yang dipilih
              if (_selectedOption == 'Tambah Produk') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductScreen(),
                  ),
                );
              } else if (_selectedOption == 'Laporan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionReportScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Tambah Produk',
                child: Text('Tambah Produk'),
              ),
              PopupMenuItem<String>(
                value: 'Laporan',
                child: Text('Laporan'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshMenus,
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: menus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final formatCurrency =
            NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(menu: menus[index]),
                  ),
                );
              },
              child: Card(
                elevation: 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.network(
                        'http://192.168.100.12/app.kasir/' +
                            menus[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menus[index].title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            limitString(menus[index].description, 10),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Price: ${formatCurrency.format(menus[index].price)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                color: Colors.blue,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Add to Cart'),
                                          content: Text('Are you sure you want to add this item to the cart?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                bool isItemExists = false;
                                                for (var item in cartItems) {
                                                  if (item.title == menus[index].title) {
                                                    item.quantity += 1;
                                                    isItemExists = true;
                                                    break;
                                                  }
                                                }
                                                if (!isItemExists) {
                                                  menus[index].quantity = 1;
                                                  cartItems.add(menus[index]);
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Product'),
                                        content: Text(
                                            'Are you sure you want to delete this product?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteMenu(menus[index].id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(cartItems: cartItems),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  void addToCart(Menu menu) {
    setState(() {
      cartItems.add(menu);
    });
  }
}
