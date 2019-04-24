import 'package:bloodms/model/user_model.dart';
import 'package:bloodms/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Donor extends StatefulWidget {
  @override
  _DonorState createState() => _DonorState();
}

class _DonorState extends State<Donor> {
  bool index = true;
  final bool horizontal = false;
  GoogleMapController controller;
  List<UserModel> donors;
  LatLng currentLocation;
  List<Marker> markers = [];
  onDonorMapCreated(
      GoogleMapController controller, LatLng donorLocation) async {
    this.controller = controller;
    // var locationData = await Location().getLocation();
    currentLocation = LatLng(donorLocation.latitude, donorLocation.longitude);

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

  Widget _dialogBuilder(BuildContext context, LatLng location) {
    return SimpleDialog(
      children: <Widget>[
        Container(child: IconButton(icon: Icon(Icons.close,color: Colors.red,),onPressed: ()=>Navigator.pop(context),),),
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(),
          child: GoogleMap(
              onMapCreated: (controller) =>
                  onDonorMapCreated(controller, location),
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 6,
              ),
              markers: Set<Marker>.of(markers)),
        ),
      ],
    );
  }

  getList() {
    if (donors == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Padding(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: donors.length,
          itemBuilder: (context, i) {
            var donor = donors[i];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context:context,
                  builder:(context)=>
                _dialogBuilder(
                    context, LatLng(donor.latitude, donor.longitude)));
              },
              child: Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.0, 30.0, 0, 10),
                  // constraints: BoxConstraints.expand(),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Name:${donor.name}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            MdiIcons.water,
                            size: 55,
                            color: Colors.red.shade800,
                          )
                        ],
                      ),
                      // Container(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Contact: ${donor.contact}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Text(
                              ' ${donor.blood}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              height: 2.0,
                              width: 18.0,
                              color: Color(0xff00d6ff)),
                        ],
                      ),
                    ],
                  ),
                ),
                height: 154.0,
                margin: EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.red, Colors.teal]),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
