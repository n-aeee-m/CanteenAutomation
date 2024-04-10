import 'dart:io';

class AddItemModel{
  final String name;
  final String price;
  final String disprice;
  final String imgFileurl;
  final String description;
  final String category;
  final String quantity;
  final bool availabilityStatus;
  final String canteenId;
  

  AddItemModel({required this.name, required this.price, required this.description, required this.category, required this.disprice, required this.imgFileurl, required this.quantity, required this.availabilityStatus, required this.canteenId, });
}
