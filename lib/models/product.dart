class Product {
  String? id;
  String name;
  String brand;
  String model;
  int quantity;
  String unit;
  String type; 
  String? assignedTo;
  String? description;
  DateTime date;

  Product({
    this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.quantity,
    required this.unit,
    required this.type,
    this.assignedTo,
    this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'model': model,
      'quantity': quantity,
      'unit': unit,
      'type': type,
      'assignedTo': assignedTo,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'],
      brand: map['brand'],
      model: map['model'],
      quantity: map['quantity'],
      unit: map['unit'],
      type: map['type'],
      assignedTo: map['assignedTo'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}