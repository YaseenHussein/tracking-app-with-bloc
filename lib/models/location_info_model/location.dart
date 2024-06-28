import 'lat_lng.dart';

class LocationModel {
  LatLngModel? latLngModel;

  LocationModel({this.latLngModel});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        latLngModel: json['latLng'] == null
            ? null
            : LatLngModel.fromJson(json['latLng'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'latLng': latLngModel?.toJson(),
      };
}
