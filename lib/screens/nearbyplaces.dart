import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class NearbyPlacesScreen extends StatefulWidget {
  final LatLng initialPosition;

  NearbyPlacesScreen({required this.initialPosition, required Latlng});

  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _searchNearbyPlaces(LatLng location) async {
    final places = GoogleMapsPlaces(apiKey: 'AIzaSyBAcjxEiRdrBUZ7DF5LDSO5ebUYWatFahE');

    final response = await places.searchNearbyWithRadius(
        Location(lat: 26.732311, lng: 88.410286), 30,
        type: "pharmacies");

    if (response.status == "OK") {
      final places = response.results;

      setState(() {
        _markers.clear();
        _markers = places
            .map((place) => Marker(
          markerId: MarkerId(place.id!),
          position: LatLng(
              place.geometry!.location.lat ?? 0,
              place.geometry!.location.lng ?? 0),
          infoWindow: InfoWindow(title: place.name!),
        ))
            .toList();
      });

      final bounds = _calculateBounds(_markers);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  LatLngBounds _calculateBounds(List<Marker> markers) {
    double minLat = markers[0].position.latitude;
    double maxLat = markers[0].position.latitude;
    double minLng = markers[0].position.longitude;
    double maxLng = markers[0].position.longitude;

    for (final marker in markers) {
      if (marker.position.latitude < minLat) {
        minLat = marker.position.latitude;
      }
      if (marker.position.latitude > maxLat) {
        maxLat = marker.position.latitude;
      }
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchNearbyPlaces(widget.initialPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places'),
      ),
      body: GoogleMap(
        initialCameraPosition:
        CameraPosition(target: widget.initialPosition, zoom: 15),
        onMapCreated: _onMapCreated,
        markers: _markers.toSet(),
      ),
    );
  }
}
