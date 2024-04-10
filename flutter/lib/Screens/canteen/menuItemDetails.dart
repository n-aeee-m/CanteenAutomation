import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartcanteen/Screens/canteen/canteenHome.dart';
import 'package:smartcanteen/Services/canteen/deleteItemApi.dart';
import 'package:smartcanteen/Services/canteen/editItemApi.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/getAllMenu.dart';
import 'package:smartcanteen/data%20models/canteen/editMenuItemModel.dart';

class ItemDetailsScreens extends StatefulWidget {
  final GetMenuModel item;

  ItemDetailsScreens({required this.item});

  @override
  State<ItemDetailsScreens> createState() => _ItemDetailsScreensState();
}

class _ItemDetailsScreensState extends State<ItemDetailsScreens> {
  late TextEditingController nameController;
  late TextEditingController discountController;
  late TextEditingController priceController;
  late TextEditingController countController;
  late TextEditingController imageUrlController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;

  ValueNotifier<bool> isReadOnly = ValueNotifier(true);
  ValueNotifier<bool> isViewProfile = ValueNotifier(true); 
  ValueNotifier<bool> isLoading = ValueNotifier(false); 
  String? _pickedImagePath;

    Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImagePath = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.mitemName);
    priceController =
        TextEditingController(text: widget.item.mprice.toString());
    discountController =
        TextEditingController(text: widget.item.mdiscountprice.toString());
    countController =
        TextEditingController(text: widget.item.quantity.toString());
    //imageUrlController = TextEditingController(text: widget.item.ima);
    descriptionController =
        TextEditingController(text: widget.item.description);
    categoryController = TextEditingController(text: widget.item.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ValueListenableBuilder(
          valueListenable: isViewProfile,
          builder: (BuildContext context, value, Widget? child) { return
          ListView(
            children: [
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
               InkWell(
                 onTap: () {
                   if (isViewProfile.value == false) {
                     isViewProfile.value = true;
                   }
                   else{
                     return;
                   }
                 },
                 child: Container(
                   height: 40,
                   width: 130,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.white),
                     borderRadius: BorderRadius.circular(7),
                     color: isViewProfile.value? Color.fromARGB(255, 16, 56, 89):Colors.white70
                   ),
                   child: Center(child: Text("View Item", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: isViewProfile.value? Colors.white : const Color.fromARGB(255, 1, 29, 51)),),),
                 ),
               ),
               InkWell(
                 onTap: () {
                   if (isViewProfile.value == true) {
                     isViewProfile.value = false;
                   }
                   else{
                     return;
                   }
                 },
                 child: Container(
                   height: 40,
                   width: 130,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.white),
                     borderRadius: BorderRadius.circular(7),
                     color: isViewProfile.value? Colors.white70 : Color.fromARGB(255, 16, 56, 89)
                   ),
                    child: Center(child: Text("Update", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: isViewProfile.value? const Color.fromARGB(255, 1, 29, 51) : Colors.white),),),
                 ),
               )
                              ],),
                                            SizedBox(height: 10),
             isViewProfile.value? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(66, 224, 222, 222)),
                        borderRadius: BorderRadius.circular(10)),
                    height: 90,
                    width: 120,
                    child: Image.network(
                      widget.item.mimage != null ? widget.item.mimage! : "https://th.bing.com/th/id/OIP.MvgjeMBHxcKil9_H4jQcvgAAAA?rs=1&pid=ImgDetMain",
                    ),
                  ):      
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pickedImagePath != null
                  ? Image.file(
                      File(_pickedImagePath!),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(),
                  SizedBox(height: 15,),
                  Text("Pick Image"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: (){_pickImage(ImageSource.camera);}, icon: Icon(Icons.camera, size: 18,)),
                      Text("Camera")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){_pickImage(ImageSource.gallery);}, icon: Icon(Icons.image,size :18)),
                      Text("Gallery")
                    ],
                  )
                ],
              ),

                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Name'),
               // keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: descriptionController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Description'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: priceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Price'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: discountController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Staff Price'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: countController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Availability count'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter available item count';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: isViewProfile.value? true: false ,
                controller: categoryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Category'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14,),

              isViewProfile.value? 
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, value, Widget? child) { 
                  return ElevatedButton.icon(onPressed: () async{
                  print(widget.item.mcanteenId);
                  
                  await deleteItem();
                }, icon: Icon(Icons.delete),
                label: isLoading.value? Center(child: CircularProgressIndicator(),) : Text("Delete"));
                 },
                
              )
              
              : 
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, value, Widget? child) { 
                  return ElevatedButton(onPressed: () async{
                    if (_pickedImagePath == null) {
                      _pickedImagePath = await widget.item.mimage;
                    }
                  print(widget.item.mcanteenId);
                  
                  await editItemApiCall();
                }, child: isLoading.value? Center(child: CircularProgressIndicator(),) : Text("Save"));
                 },
                
              )
            ],
          );  },
        ),
      ),
    );
  }
  editItemApiCall() async{
    isLoading.value = true;
    final item = await EditItemModel(name: nameController.text, price: priceController.text, description: descriptionController.text, category: categoryController.text, disprice: discountController.text, imgFileurl: _pickedImagePath!, quantity: countController.text, availabilityStatus: true, canteenId: widget.item.mcanteenId.toString(), itemId: widget.item.mitemId.toString());
                final res =  await editItemApi(item);
                if(res == "success"){
                  isLoading.value = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Item has been updated successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => canteenHomeScreen(),));
                }
                else{
                  isLoading.value = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
                }
  }



  //delete Item

  deleteItem() async{
    final resp = await deleteItemApi(widget.item.mitemId.toString());
    if(resp == "success"){
                  isLoading.value = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Item has been deleted successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => canteenHomeScreen(),));
                }
                else{
                  isLoading.value = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
                }
  }
}
