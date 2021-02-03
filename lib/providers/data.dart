import 'dart:convert';
import 'package:http/http.dart' as http;

class DataGQL {
  String _uri;
  String _token;

  Future<dynamic> cQuery(String query, uri, token) async {
    print('QUERY EJECUTADA');
    // print('QUERY EJECUTADAAAAAAAAAAAAAAAAAAAAAA:: $query');
    Map<String, dynamic> quer = {'query': query};
    var querr = json.encode(quer);
    try {
      var response = await http.post(
        uri,
        body: querr,
        headers: {
          'Content-Type': 'application/json',
          'dataType': 'json',
          'Authorization': 'Bearer $token'
        },
      );

      // print(response.body);
      var parsedResponse = json.decode(response.body);

      // print(parsedResponse);

      return parsedResponse;
    } catch (error) {
      throw error;
    }
  }
}
