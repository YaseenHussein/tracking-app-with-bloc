import 'package:location/location.dart';
import 'package:tracking_app_with_cubit/utils/errors/location_expeption.dart';

class LocationServices {
  Location location = Location();
  Future<void> checkAndRequestLocationService() async {
    bool isServicesEnable = await location.serviceEnabled();
    if (!isServicesEnable) {
      bool clientEnableServices = await location.requestService();
      if (!clientEnableServices) {
        throw LocationServicesException(message: "user not enable services");
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException(message: "the user give deniedForever");
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationPermissionException(message: "the user give  denied");
      }
    }
  }

  Future<LocationData> getUserLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return location.getLocation();
  }

  void getRealTimeLocation({
    required void Function(LocationData)? onData,
  }) async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    location.onLocationChanged.listen(onData);
  }
}
