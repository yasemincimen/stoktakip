import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'add_product_page.dart';

class ProductListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts(String type) {
    return _firestore
        .collection('stoklar')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stoklar")),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Elde Olanlar'),
                      Tab(text: 'Zimmetlenenler'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // "Elde Olanlar" Tab'ı
                        _buildProductList('elde'),
                        // "Zimmetlenenler" Tab'ı
                        _buildProductList('zimmet'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              ),
              child: Text('Ürün Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(String type) {
    return StreamBuilder<List<Product>>(
      stream: getProducts(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu.'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Ürün bulunamadı.'));
        }

        var products = snapshot.data!;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];

            return ListTile(
              title: Text(product.name),
              subtitle: Text('Miktar: ${product.quantity} ${product.unit}'),
              trailing: product.type == 'zimmet'
                  ? Text('Zimmetli: ${product.assignedTo}')
                  : null,
            );
          },
        );
      },
    );
  }
}
