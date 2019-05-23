import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<Marker> markers = [];
  GoogleMapController controller;
  LatLng currentLocation;

  onMapCreated(GoogleMapController controller) async {
    this.controller = controller;
    var locationData = await Location().getLocation();
    currentLocation = LatLng(locationData.latitude, locationData.longitude);
    print(locationData.longitude);
    print(locationData.latitude);
    setState(() {
      markers.add(
        Marker(
            markerId: MarkerId("Mylocation"),
            position: currentLocation,
            draggable: true,
            onTap: () {
              print("tapped");
            },
            consumeTapEvents: true,
            infoWindow: InfoWindow(title: "Your location")),
      );
    });

    controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your Location'),
      ),
      body: GoogleMap(
          onMapCreated: (controller) => onMapCreated(controller),
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 6,
          ),
          markers: Set<Marker>.of(markers)),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Pick'),
        icon: Icon(Icons.location_on),
        onPressed: () {
          Navigator.pop(context, currentLocation);
        },
      ),
    );
  }
}
