import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';



class MedicineShopLocator extends StatefulWidget {
  @override
  _MedicineShopLocatorState createState() => _MedicineShopLocatorState();
}

class _MedicineShopLocatorState extends State<MedicineShopLocator> {
  late GoogleMapController _mapController;
  Location _location = Location();
  late LatLng _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      _moveCamera();
    } catch (e) {
      print(e);
    }
  }

  void _moveCamera() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 15)));

  }

  Future<void> _searchNearbyMedicineShops() async {
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation.latitude},${_currentLocation.longitude}&radius=50&type=pharmacy&key=AIzaSyBAcjxEiRdrBUZ7DF5LDSO5ebUYWatFahE';
    var response = await http.get(Uri.parse(url));
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 15)));
    /*var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      print('No internet connection');
      return;
    }*/

    var jsonResponse = jsonDecode(response.body);
    List<dynamic> results = jsonResponse['results'];
    _addMarkers(results);
  }

  void _addMarkers(List<dynamic> places) {
    places.forEach((place) {
      double lat = place['geometry']['location']['lat'];
      double lng = place['geometry']['location']['lng'];
      String name = place['name'];
      String address = place['vicinity'];
      LatLng latLng = LatLng(lat, lng);
      Marker marker = Marker(
        markerId: MarkerId(name),
        position: latLng,
        infoWindow: InfoWindow(title: name, snippet: address),
      );
      setState(() {
        _markers.add(marker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shop Locator'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 10,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _searchNearbyMedicineShops,
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}


