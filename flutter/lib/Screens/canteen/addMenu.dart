import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartcanteen/Screens/canteen/canteenHome.dart';
import 'package:smartcanteen/Services/canteen/additemApi.dart';
import 'package:smartcanteen/data%20models/canteen/addItemModel.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/data%20models/menuItemModel.dart';

class AddMenuScreen extends StatefulWidget {
  //final List<MenuItem> menulist;

  AddMenuScreen();

  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController countController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController discountpriceController;
  late TextEditingController quantityController;

  String? _pickedImagePath;
  String? _selectedCategory;

  ValueNotifier<bool> isLoading = ValueNotifier(false); 

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    countController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = TextEditingController();
    discountpriceController = TextEditingController();
    quantityController = TextEditingController();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add New Item to Menu'),
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pickedImagePath != null
                  ? Image.file(
                      File(_pickedImagePath!),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: discountpriceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Discount Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: countController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a count';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text("Pick Image"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: (){_pickImage(ImageSource.camera);}, icon: Icon(Icons.camera, size: 29,)),
                      Text("Camera")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){_pickImage(ImageSource.gallery);}, icon: Icon(Icons.image,size :29)),
                      Text("Gallery")
                    ],
                  )
                ],
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
Container(
  height: 60,
  decoration: BoxDecoration(
    border: Border.all(),
    borderRadius: BorderRadius.circular(10)
  ),
  child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: <String>['meals', 'snack', 'drinks'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Category'),
            ),
),
              SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, value, Widget? child) { return ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      await addItemFunc();
                    }
                     // await addItemFunc();
                    }
                  ,
                  child: isLoading.value? Center(child: CircularProgressIndicator(),) : Text('Add'),
                ); }
              ),
            ],
          ),
        ),
      ),
    );
  }

  addItemFunc() async{
    isLoading.value = true;print(userId);
    final item = await AddItemModel(name: nameController.text, price: priceController.text, description: descriptionController.text, category: _selectedCategory!, disprice: discountpriceController.text, imgFileurl: _pickedImagePath!, quantity: countController.text, availabilityStatus: true, canteenId: userId.toString());
                   final resp = await addItemApi(item);
                   if(resp == "success"){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Item has been added successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
            isLoading.value = false;

            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>canteenHomeScreen(),));
                   }
                   else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));

            isLoading.value = false;
                   }
  }
}
