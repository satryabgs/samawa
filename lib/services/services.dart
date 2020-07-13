//

import '../models/timeAdzan.dart';
import '../models/allCity.dart';
import 'package:http/http.dart' as http;

class Services{
  //
  static const String url = '';

  static Future<TimeAdzan> getTime(String location,String date) async{
      final response = await http.get(Uri.encodeFull("https://api.banghasan.com/sholat/format/json/jadwal/kota/$location/tanggal/$date"));
      return timeAdzanFromJson(response.body);
  }

  static Future<AllCity> getCode(String location) async{
      final response = await http.get(Uri.encodeFull("https://api.banghasan.com/sholat/format/json/kota/nama/$location"));
      return allCityFromJson(response.body);
  }

}

