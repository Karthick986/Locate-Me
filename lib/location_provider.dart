import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;

  Position get position => _position;
  Placemark _address = Placemark();

  Placemark get address => _address;

  // for get current location
  void getCurrentLocation({GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(newLocalData.latitude, newLocalData.longitude), zoom: 17)));
        _position = newLocalData;

        List<Placemark> placemarks = await placemarkFromCoordinates(newLocalData.latitude, newLocalData.longitude);
        _address = placemarks.first;
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  // update position on location marker
  void updatePosition(CameraPosition position) async {
    _position = Position(
      latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
      heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
    );
    _loading = true;
    notifyListeners();
  }

  // End address position
  void dragableAddress() async {
    try {
      notifyListeners();
      List<Placemark> placemarks = await placemarkFromCoordinates(_position.latitude, _position.longitude);
      _address = placemarks.first;
      _loading = false;
      notifyListeners();
    }catch(e) {
      _loading = false;
      notifyListeners();
    }
  }
}
