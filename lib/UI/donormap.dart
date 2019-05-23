import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DonorMap extends StatefulWidget {
  DonorMap(
      {this.donorLocation,
      this.height,
      this.width,
      this.isNotExitable = false});
  final LatLng donorLocation;
  final double height;
  final double width;
  final bool isNotExitable;
  @override
  _DonorMapState createState() => _DonorMapState();
}

class _DonorMapState extends State<DonorMap> {
  LatLng currentDonorLocation;
  GoogleMapController controller;
  List<Marker> marker = [];
  LatLng location;

  onDonorMapCreated(
      GoogleMapController controller, LatLng donorLocation) async {
    this.controller = controller;
    currentDonorLocation =
        LatLng(donorLocation.latitude, donorLocation.longitude);
    print(currentDonorLocation);
    setState(() {
      marker.add(
        Marker(
            markerId: MarkerId("Mylocation"),
            position: currentDonorLocation,
            draggable: true,
            onTap: () {
              print("tapped");
            },
            consumeTapEvents: true,
            infoWindow: InfoWindow(title: "Your location")),
      );
    });

    controller
        .animateCamera(CameraUpdate.newLatLngZoom(currentDonorLocation, 15));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      location = widget.donorLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(),
        child: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (controller) =>
                onDonorMapCreated(controller, location),
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 6,
            ),
            markers: Set<Marker>.of(marker)),
      ),
      widget.isNotExitable
          ? SizedBox(width: 0.0, height: 0.0)
          : IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.pop(context)),
    ]);
  }
}
