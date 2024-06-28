import 'route_model.dart';

class RouteInfoModel {
  List<RouteModel>? routes;

  RouteInfoModel({this.routes});

  factory RouteInfoModel.fromJson(Map<String, dynamic> json) {
    return RouteInfoModel(
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'routes': routes?.map((e) => e.toJson()).toList(),
      };
}
