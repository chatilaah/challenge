import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.longitude, required this.latitude})
      : super(key: key);

  final double longitude;
  final double latitude;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = Completer<GoogleMapController>();

  var markers = <MarkerId, Marker>{};

  late BitmapDescriptor myIcon;
  late BitmapDescriptor myLocationIcon;

  setPinDrop() async {
    const pmiAsset = "assets/images/pin_marker.png";

    myIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(22, 22)), pmiAsset);

    _goToPos(lat: widget.latitude, lon: widget.longitude);
  }

  Future<void> _goToPos({
    double lat = 0.00,
    double lon = 0.00,
    bool setMarker = true,
    bool clearLastMarker = true,
  }) async {
    if (clearLastMarker) {
      setState(() {
        markers.clear();
      });
    }

    if (setMarker) {
      var markerIdVal = '$lat,$lon';
      final MarkerId markerId = MarkerId(markerIdVal);
      final Marker marker = Marker(
        icon: lat == 0.0 ? myLocationIcon : myIcon,
        markerId: markerId,
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow:
            InfoWindow(title: '${widget.latitude}, ${widget.longitude}'),
      );

      setState(() {
        markers[markerId] = marker;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      final GoogleMapController controller = await _controller.future;
      controller.showMarkerInfoWindow(MarkerId(markerIdVal));
    }

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(widget.latitude, widget.longitude),
            tilt: 0,
            zoom: 17.00),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Framework')),
      body: GoogleMap(
        compassEnabled: false,
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        initialCameraPosition: CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(widget.latitude, widget.longitude),
          tilt: 0,
          zoom: 20.00,
        ),
        // zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          setPinDrop();

          // controller.setMapStyle(
          //   '[{"featureType": "poi","stylers": [{"visibility": "off"}]}]',
          // );
        },
      ),
    );
  }
}
