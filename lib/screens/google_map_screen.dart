import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:google_maps_controller/google_maps_controller.dart';
//import 'package:geolocator/geolocator.dart';

class Data {
  final List? geocodedwaypoints;
  final List? routes;

  Data({this.geocodedwaypoints, this.routes});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        geocodedwaypoints: json['geocoded_waypoints'], routes: json['routes']);
  }
}

class GoogleMapScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String ip;
  GoogleMapScreen(this.lat, this.long, this.ip);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState(lat, long, ip);
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  //final Future<Data> data = fetchData();
  //Completer<GoogleMapController> _controller = Completer();
  //GoogleMapController? _controller;
  //final Set<Polyline> polyline = {};
  //List<LatLng> routeCoords=[];
  //GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ");
  double lat;
  String ip;
  double long;
  double? newlat;
  double? newlong;

  _GoogleMapScreenState(this.lat, this.long, this.ip);
  List<Marker> allMarkers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  
  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    //Completer<GoogleMapController> _controller = Completer();
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //futureData = fetchData();
    allMarkers.add(Marker(
        markerId: MarkerId('destinationmarker'),
        infoWindow: const InfoWindow(title: 'destintion'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(lat + 0.2, long),
        draggable: true,
        onDragEnd: ((newPosition) {
          newlat = newPosition.latitude;
          newlong = newPosition.longitude;
          //getsomepoints();
          print(newPosition.latitude);
          print(newPosition.longitude);
        })));

    allMarkers.add(Marker(
      markerId: MarkerId('mymarker'),
      infoWindow: const InfoWindow(title: 'Source'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(lat, long),
      draggable: false,
      onTap: () {
        print('Marker Tapped');
        print(lat);
        print(long);
      },
    ));
  }
  void getPolyline(latfinal, lngfinal) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ',
      PointLatLng(lat, long),
      PointLatLng(latfinal, lngfinal),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }
  Future<String> fetchData(lat, long, newLat, newLong) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$newLat,$newLong&key=AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ'));
    //print ('https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$newLat,$newLong&key=AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ');

    return response.body;
  }
  Future<Data> postData(String body) async {
    //print('dsds');
    print(body);
    final response = await http.post(
      Uri.parse('http://10.2.153.120:5000/users'),
      headers: <String, String>{
        'Content_Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        "body" : body,
      }),
    );
      if (response.statusCode == 201) {
        //print('hellooooo');
        return Data.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('falied to sent the data');
          }

    
  }

void foo(lat, long, newLat, newLong) async {
  final user = await fetchData(lat, long, newLat, newLong);
  getPolyline(newLat, newLong);
  postData(user);
  print(ip);
}
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            //onMapCreated: onMapCreated,
            //polylines: polyline,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
                target: LatLng(lat, long), zoom: 12.0), //camera position
            mapType: MapType.normal,
            markers: Set.from(allMarkers),
            //onMapCreated: (GoogleMapController controller){
              //_controller.complete(controller);
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                  onPressed: () => foo(lat, long, newlat, newlong),
                  child: Text('Start')),
            ),
          )

          // FloatingActionButton(onPressed:()=> fetchData(lat,long,newlat,newlong), child: Text('press heree'))
        ],
      ),
    );
  }

  /*void onMapCreated(GoogleMapController controller){
    setState(() {
      _controller = controller;

      polyline.add(Polyline(
        polylineId: PolylineId('route1'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.red,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,   
      ));
    });
  }*/
}
