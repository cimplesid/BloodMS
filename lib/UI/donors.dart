import 'dart:collection';

import 'package:bloodms/model/user_model.dart';
import 'package:bloodms/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Donor extends StatefulWidget {
  @override
  _DonorState createState() => _DonorState();
}

class _DonorState extends State<Donor> {
  bool index = true;
  GoogleMapController controller;
  List<UserModel> donors;
  LatLng currentLocation;
  List<Marker> markers = [];

  void onMapCreated(GoogleMapController controller) async {
    this.controller = controller;
    var locationData = await Location().getLocation();
    currentLocation = LatLng(locationData.latitude, locationData.longitude);

    donors.forEach((d) {
      markers.add(Marker(
        markerId: MarkerId("${d.name} location"),
        position: LatLng(d.latitude, d.longitude),
        infoWindow: InfoWindow(title: '${d.name}'),
      ));
    });

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
    controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 13));
  }

  getMap() {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition:
          CameraPosition(target: LatLng(27.74344, 85.3202), zoom: 5),
      markers: Set<Marker>.of(markers),
      onMapCreated: (controller) => onMapCreated(controller),
    );
  }

  getList() {
    if (donors == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return ListView.builder(
        itemCount: donors.length,
        itemBuilder: (context, i) {
          var donor = donors[i];
          return ListTile(
            leading: Text(donor.name),
            subtitle: Text(donor.contact),
            trailing: Text(donor.blood),
            // isThreeLine: true,
          );
        },
      );
  }

  @override
  void initState() {
    super.initState();
    FirestoreProvider().getUsers().then((document) {
      setState(() {
        donors = document;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Donors'),
          actions: <Widget>[
            IconButton(
              icon: Icon(index ? Icons.map : Icons.list),
              onPressed: () {
                setState(() {
                  index = !index;
                });
              },
            )
          ],
        ),
        body: index ? getList() : getMap());
  }
}
