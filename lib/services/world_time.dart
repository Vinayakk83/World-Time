import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for UI
  String time; // the time in that location
  String flag; // url to asset flag icon
  String url; // location url for API endpoint
  bool isDayTime; // true or false if Daytime or not

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      // make the request
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      // print(data);

      // get properties of data
      String dateTime = data['datetime'];
      String offSetHours = data['utc_offset'].substring(1, 3);
      String offSetMinutes = data['utc_offset'].substring(4, 6);
      // print(dateTime);
      // print(offSet);

      // create datetime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(offSetHours)));
      now = now.add(Duration(minutes: int.parse(offSetMinutes)));

      // setup the time
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
      // print(now);
    } catch (e) {
      print("Caught Error: $e");
      time = "Could not get time data";
    }
  }
}
