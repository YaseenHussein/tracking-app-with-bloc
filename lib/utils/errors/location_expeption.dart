class LocationServicesException implements Exception {
  final String message;

  LocationServicesException({required this.message});
}

class LocationPermissionException implements Exception {
  final String message;

  LocationPermissionException({required this.message});
}
