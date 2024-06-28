import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tracking_app_with_cubit/models/place_details_model/place_details_model.dart';
import 'package:tracking_app_with_cubit/models/places_autocomplete/places_autocomplete_model.dart';

class PlacesServices {
  final String baseUrl = "https://maps.googleapis.com/maps/api/place";
  final String apiKey = "AIzaSyC63hxrJucY0A_kVtcugY2p-W4Wk0MDVGM";
  Future<List<PlacesAutocompleteModel>> getPlaces(
      {required String input, required String sessionToken}) async {
    var response = await http.get(Uri.parse(
        "$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sessionToken&components=country:ye"));
    if (response.statusCode == 200) {
      List<PlacesAutocompleteModel> places = [];
      for (var element in jsonDecode(response.body)['predictions']) {
        places.add(PlacesAutocompleteModel.fromJson(element));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlacesDetails({required String placesId}) async {
    var response = await http.get(Uri.parse(
        "$baseUrl/details/json?place_id=$placesId&key=$apiKey&components=country:ye"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];
      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
