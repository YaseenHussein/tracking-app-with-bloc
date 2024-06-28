import 'dart:convert';

import 'package:tracking_app_with_cubit/models/location_info_model/location_info_model.dart';
import 'package:tracking_app_with_cubit/models/route_info_model/route_info_model.dart';
import 'package:tracking_app_with_cubit/models/route_info_model/route_model.dart';
import 'package:tracking_app_with_cubit/models/route_modeifiers_model.dart';
import 'package:http/http.dart' as http;

class RouteServices {
  final String baseUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apiKey = "AIzaSyC63hxrJucY0A_kVtcugY2p-W4Wk0MDVGM";
  Future<RouteModel> getRouteDetails({
    RouteModifiersModel? routeModifiersModel,
    required LocationInfoModel destination,
    required LocationInfoModel origin,
  }) async {
    Uri url = Uri.parse(baseUrl);
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destination.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers":
          routeModifiersModel?.toJson() ?? RouteModifiersModel().toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL",
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: header);
    if (response.statusCode == 200) {
      var data = RouteInfoModel.fromJson(jsonDecode(response.body));

      return data.routes!.first;
    } else {
      throw Exception();
    }
  }
}
