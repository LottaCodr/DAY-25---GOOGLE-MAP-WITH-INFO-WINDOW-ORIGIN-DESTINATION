import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mygoogle/directions_repo.dart';
import 'package:mygoogle/model/directions_model.dart';

void main() => runApp(MaterialApp(
      home: const MyMap(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange),
    ));

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(9.0765, 7.3986), zoom: 11.5);

  GoogleMapController? _googleMapController;
  late Marker? _origin = null;
  late Marker? _destination = null;
  Directions? _info;

  @override
  void dispose() {
    super.dispose();
    _googleMapController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Lota Map',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController?.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(
                      target: _origin?.position ?? const LatLng(0, 0),
                      zoom: 14.5,
                      tilt: 50.0))),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController?.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(
                      target: _destination?.position ?? const LatLng(0, 0),
                      zoom: 14.5,
                      tilt: 50.0))),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)),
              child: const Text('DES'),
            ),
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin!,
          if (_destination != null) _destination!
        },
        onLongPress: _addMarker,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController?.animateCamera(
            _info != null ?
                CameraUpdate.newLatLngBounds(_info?.bounds ?? , 100) :
              CameraUpdate.newCameraPosition(_initialCameraPosition))),
    );
  }

  Future<void> _addMarker(LatLng pos) async {
    if ((_destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue));
      });
      
      final directions = await DirectionsRepo(dio: null ).getDirections(origin: _origin?.position ?? pos, destination: pos);
      setState(() {
        _info = directions;
      });
    }
  }
}
