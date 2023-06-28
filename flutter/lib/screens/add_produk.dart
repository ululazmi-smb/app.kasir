import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage(File? imageFile) async {
    if (imageFile == null) {
      return;
    }

    var stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('http://192.168.100.12/app.kasir/api/menu/add');

    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile('gambar', stream, length,
        filename: imageFile.path, contentType: MediaType('image', 'jpeg'));
    request.files.add(multipartFile);

    // Mengirim data form lainnya
    request.fields['name'] = _nameController.text;
    request.fields['price'] = _priceController.text;
    request.fields['detail'] = _detailController.text;

    try {
      setState(() {
        _isLoading = true;
      });

      var response = await request.send();
      var responseString = await http.Response.fromStream(response);
      String errorResponse = responseString.body;
      // Lakukan tindakan yang diperlukan setelah berhasil mengirim foto
      print(errorResponse);
      if (response.statusCode == 200) {
        // Berhasil mengirim foto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product saved successfully'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        // Gagal mengirim foto
        // Lakukan tindakan yang diperlukan jika gagal mengirim foto
        print('Failed to upload image');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: _chooseImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _imageFile != null
                  ? Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.add_a_photo,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _detailController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Detail',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
              _uploadImage(_imageFile);
            },
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Save Product'),
          ),
        ],
      ),
    );
  }

}
