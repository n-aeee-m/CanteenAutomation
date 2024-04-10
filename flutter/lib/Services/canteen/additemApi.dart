
import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/canteen/addItemModel.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';



Future<String> addItemApi(AddItemModel item) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/menu/'),
    );

    request.fields['mitem_name'] = item.name;
    request.fields['mprice'] = item.price;
    request.fields['mdiscountprice'] = item.disprice; 
    request.fields['description'] = item.description;
    request.fields['categories'] = item.category;
    request.fields['quantity'] = item.quantity;
    request.fields['availability_status'] = item.availabilityStatus.toString();
    request.fields['mrating'] = '0';
    request.fields['mcanteen_id'] = item.canteenId;
    request.files.add(await http.MultipartFile.fromPath(
      'mimage',
      item.imgFileurl,
    ));

    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201 ) {
      print('Menu item added successfully');
      return "success";
    } else {
      print('Failed to add menu item: ${response.statusCode}');
      return "failed";
    }
  } catch (e) {
    print('Error adding menu item: $e');
    return "failed";
  }
}

