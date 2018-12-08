import 'dart:io';
import 'dart:convert';

class NetworkUtil {

  static Future<String> getJson(String url, Map<String, String> paramMap) async{

    var httpClient = new HttpClient();

    var jsonStr = "";

    if(paramMap != null && paramMap.length > 0) {
      url = url + "?";
      for(var key in paramMap.keys) {
        url = "$url$key=${paramMap['$key']}&";
      }

      url = url.substring(0, url.length-1);
    }

    print(url);

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        jsonStr = await response.transform(utf8.decoder).join();
      }
    } catch (exception) {
    }

    return jsonStr;
  }
}