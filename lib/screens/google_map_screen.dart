//import 'dart:ffi';
//import 'dart:html';
//import 'package:permission/permission.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_map_polyline/google_map_polyline.dart';
//import 'package:google_maps_controller/google_maps_controller.dart';
//import 'package:geolocator/geolocator.dart';


class GoogleMapScreen extends StatefulWidget {
 final  double lat;
  final double long;
  GoogleMapScreen(this.lat, this.long);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState(lat,long);
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  //Completer<GoogleMapController> _controller = Completer();
  //GoogleMapController? _controller;
  //final Set<Polyline> polyline = {};
  //List<LatLng> routeCoords=[];
  //GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyB4_eF-2kgyM_i4l2HICBeWDonF3Su1bjQ");
  double lat;
  double long;
  
  _GoogleMapScreenState(this.lat, this.long);
  List<Marker> allMarkers= [];
  
  /*getsomepoints({newLat,newLong}) async{
    var permissions = await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain){
      var askpermissions = await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(lat,long),
        destination: LatLng(newLat?.lat+0.2,newLong?.long),
        mode: RouteMode.driving
      );
    }

  }*/

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('destinationmarker'),
      infoWindow: const InfoWindow(title: 'destintion'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(lat+0.2,long),
      draggable: true,
      onDragEnd: ((newPosition) {
        //getsomepoints();
            print(newPosition.latitude);
            print(newPosition.longitude);}
      )));

    allMarkers.add(Marker(
      markerId:MarkerId ('mymarker'),
      infoWindow: const InfoWindow(title: 'Source'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(lat,long),
      draggable: false,
      onTap: () {
        print('Marker Tapped');
        print(lat);
        print(long);
      },
      ));

  

  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            //onMapCreated: onMapCreated,
            //polylines: polyline,
            initialCameraPosition:
            CameraPosition(target: LatLng(lat,long), zoom: 12.0), //camera position
            mapType: MapType.normal,
            markers: Set.from(allMarkers),
          ),
        ),
    
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