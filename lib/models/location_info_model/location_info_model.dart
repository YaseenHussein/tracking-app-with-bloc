import 'location.dart';

class LocationInfoModel {
  LocationModel? locationModel;

  LocationInfoModel({this.locationModel});

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      locationModel: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'location': locationModel?.toJson(),
      };
}
