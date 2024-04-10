import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';

Future<String> sendOtpApi(String mail) async {

  try {
    final url = Uri.parse('$baseUrl/forgotpassword/');
    final response = await http.post(
      url,
      body: {'email': mail },
    );
    print("Status ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "success";
    } else {
      print("else");
      print(response.statusCode);
      print(response.body);
      return "failed";
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return "failed";
  }
}
