
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpapp/Constants.dart';
import 'package:gpapp/Controllers/NetworkControllers/Models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventProvider extends GetConnect {
  GetStorage ds = GetStorage();
  List<Event> events = [];
  //Fetch Data
  getEvents(var page) async {
    try {
      var response = await http.get(
        Uri.parse(Constants().baseUrl +
            "events??filter[offset]=" +
            page +
            "&filter[limit]=4"),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        for (var event in jsonResponse) {
          Event eventData = Event.fromJson(event);
          events.add(eventData);
        }

        ds.write("events", events);
        return events;
      } else {
        if (ds.read("events") != null) {
          var e = json.decode(json.encode(ds.read("events")));
          for (var i in e) {
            events.add(Event.fromJson(i));
          }

          return events;
        }

        return events;
      }
    } catch (e) {
      if (ds.read("events") != null) {
        var e = json.decode(json.encode(ds.read("events")));
        for (var i in e) {
          events.add(Event.fromJson(i));
        }

        return events;
      }
      return events;
    }
  }

  //update events
}
