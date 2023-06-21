// lib/services/api/general.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

// generic method for fetching an http document and returning it as a string
Future<String> fetchDocument(String url) async {
  // fetch the http document and store it in a variable
  var response = await http.get(Uri.parse(url));
  // if everything is ok
  if (response.statusCode == 200) {
    // parse the document and save it to a var
    final document = parse(response.body);
    // then return the text from between the <body> and </body> tags
    return document.body!.text;
  } else {
    // if something went wrong with the request
    // throw an exception
    throw Exception('Failed to load page. Status Code: ${response.statusCode}');
  }
}


Future<bool> postDocument(String url, Map<String,String> postBody) async{
  String data = jsonEncode(postBody);
  bool success = false;
  try{
    // post the http document and store the response in a variable
    var response = await http.post(Uri.parse(url), body: data);
    // if everything is ok
    if (response.statusCode == 200) {
      success = true;
    }
  } catch (e) {
    // TODO: use Logger
    print(e);
  }
  return success;
}