
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  String _type = 'elde';

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      Product newProduct = Product(
        name: _nameController.text,
        brand: _brandController.text,
        model: _modelController.text,
        quantity: int.parse(_quantityController.text),
        unit: _unitController.text,
        description: _descriptionController.text,
        assignedTo: _type == 'zimmet' ? _assignedToController.text : null,
        type: _type,
        date: DateTime.now(),
      );

      await _firestore.collection('stoklar').add(newProduct.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ürün Ekle")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                onChanged: (val) => setState(() => _type = val!),
                items: ['elde', 'zimmet']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Tür'),
              ),
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Ürün Adı'), validator: (val) => val!.isEmpty ? 'Gerekli' : null),
              TextFormField(controller: _brandController, decoration: InputDecoration(labelText: 'Marka')),
              TextFormField(controller: _modelController, decoration: InputDecoration(labelText: 'Model')),
              TextFormField(controller: _quantityController, decoration: InputDecoration(labelText: 'Miktar'), keyboardType: TextInputType.number),
              TextFormField(controller: _unitController, decoration: InputDecoration(labelText: 'Birim')),
              if (_type == 'zimmet')
                TextFormField(controller: _assignedToController, decoration: InputDecoration(labelText: 'Zimmet Alan')),
              TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Açıklama')),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _saveProduct, child: Text("Kaydet")),
            ],
          ),
        ),
      ),
    );
  }
}
