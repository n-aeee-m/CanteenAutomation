import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/canteen/editMenuItemModel.dart';

Future<String> editItemApi(EditItemModel item) async {
  try {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/canteenmenuitembyitemid/${item.itemId}'),
    );

    request.fields['mitem_id'] = item.itemId;
    request.fields['mitem_name'] = item.name;
    request.fields['mprice'] = item.price;
    request.fields['mdiscountprice'] = item.disprice; 
    request.fields['description'] = item.description;
    request.fields['categories'] = item.category;
    request.fields['quantity'] = item.quantity;
    request.fields['availability_status'] = item.availabilityStatus.toString();
    //request.fields['mrating'] = item.price;
    request.fields['mcanteen_id'] = "5";
    request.files.add(await http.MultipartFile.fromPath(
      'mimage',
      item.imgFileurl,
    ));

    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Menu item added successfully');
      return "success";
      
    } else {
      print('Failed to add menu item: ${response.statusCode}');
      return "failed";
      
    }
  } catch (e) {
    print("exception");
    return "failed";
  }
}

