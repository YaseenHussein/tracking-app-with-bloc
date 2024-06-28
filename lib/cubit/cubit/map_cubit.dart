import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app_with_cubit/cubit/cubit/map_state.dart';
import 'package:tracking_app_with_cubit/models/location_info_model/lat_lng.dart';
import 'package:tracking_app_with_cubit/models/location_info_model/location.dart';
import 'package:tracking_app_with_cubit/models/location_info_model/location_info_model.dart';
import 'package:tracking_app_with_cubit/models/place_details_model/place_details_model.dart';
import 'package:tracking_app_with_cubit/models/places_autocomplete/places_autocomplete_model.dart';
import 'package:tracking_app_with_cubit/models/route_info_model/route_model.dart';
import 'package:tracking_app_with_cubit/utils/errors/location_expeption.dart';
import 'package:tracking_app_with_cubit/utils/services/location_services.dart';
import 'package:tracking_app_with_cubit/utils/services/places_services.dart';
import 'package:tracking_app_with_cubit/utils/services/route_services.dart';
import 'package:uuid/uuid.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  static MapCubit get(context) => BlocProvider.of(context);
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  late TextEditingController inputTextController;
  late LocationServices locationServices;
  late LatLng currentLocation;
  late LatLng desLocation;
  late PlacesServices placesServices;
  late RouteServices routeServices;
  late PolylinePoints polylinePoints;
  List<LatLng> points = [];
  Set<Marker> markers = {};
  late Uuid uuid;
  String? sessionToken;
  Set<Polyline> polylines = {};
  initialCubit() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 0);
    inputTextController = TextEditingController();
    locationServices = LocationServices();
    placesServices = PlacesServices();
    uuid = const Uuid();
    routeServices = RouteServices();
    polylinePoints = PolylinePoints();
    getPlaces();
  }

  List<PlacesAutocompleteModel> allPlaces = [];
  PlaceDetailsModel? placeDetailsModel;
  Future<void> getPlaces() async {
    inputTextController.addListener(
      () async {
        sessionToken ??= uuid.v4();
        if (inputTextController.text.isNotEmpty) {
          var value = await placesServices.getPlaces(
              input: inputTextController.text, sessionToken: sessionToken!);
          allPlaces.clear();
          allPlaces.addAll(value);
          emit(AddPlacesState());
        } else {
          allPlaces.clear();
          emit(AddPlacesState());
        }
      },
    );
  }

  Future<void> getPlacesDetails({required String placesId}) async {
    allPlaces.clear();
    inputTextController.clear();
    markers.last.clone();
    placesServices.getPlacesDetails(placesId: placesId).then(
      (value) {
        placeDetailsModel = value;
        desLocation = LatLng(
          placeDetailsModel!.geometry!.location!.lat!,
          placeDetailsModel!.geometry!.location!.lng!,
        );

        markers.add(
          Marker(
            markerId: const MarkerId("des_location"),
            position: desLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );

        getRouteData();
      },
    );
  }

  LatLngBounds getLatLngBounds() {
    var southwestLat = points.first.latitude;
    var southwestLng = points.first.longitude;
    var northeastLat = points.first.latitude;
    var northeastLng = points.first.longitude;
    for (var element in points) {
      southwestLat = min(southwestLat, element.latitude);
      southwestLng = min(southwestLng, element.longitude);
      northeastLat = max(northeastLat, element.latitude);
      northeastLng = max(northeastLng, element.longitude);
    }
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLng),
        northeast: LatLng(northeastLat, northeastLng));
  }

  RouteModel? routeModel;
  Future<void> getRouteData() async {
    LocationInfoModel destination = LocationInfoModel(
        locationModel: LocationModel(
      latLngModel: LatLngModel(
        latitude: desLocation.latitude,
        longitude: desLocation.longitude,
      ),
    ));
    LocationInfoModel origin = LocationInfoModel(
        locationModel: LocationModel(
      latLngModel: LatLngModel(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      ),
    ));
    routeModel = await routeServices.getRouteDetails(
        destination: destination, origin: origin);

    drawPolyline();
  }

  void drawPolyline() {
    polylines.clear();
    points.clear();
    allPlaces.clear();
    List<PointLatLng> result =
        polylinePoints.decodePolyline(routeModel!.polyline!.encodedPolyline!);
    points.addAll(result.map((e) => LatLng(e.latitude, e.longitude)).toList());

    Polyline polyline = Polyline(
      polylineId: const PolylineId("my_route_polylineId"),
      color: Colors.blue,
      points: points,
    );
    polylines.add(polyline);
    LatLngBounds latLngBounds = getLatLngBounds();
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 30));
    emit(GetRouteDataState());
  }

  updateCameraLocation() async {
    try {
      var userLocation = await locationServices.getUserLocation();
      currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
      var currentCamera = CameraPosition(target: currentLocation, zoom: 16);
      Marker marker = Marker(
          markerId: const MarkerId(
            "user_current_location",
          ),
          position: currentLocation);
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(currentCamera));
      markers.add(marker);
      emit(AddMarkerState());
    } on LocationPermissionException catch (e) {
      print(e.message);
    } on LocationServicesException catch (e) {
      print(e.message);
    } on Exception catch (e) {
      print(e);
    }
  }
}
