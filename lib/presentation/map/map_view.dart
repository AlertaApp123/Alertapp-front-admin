import 'package:alertapp_admin/core/styles/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView>
    with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive => true;

  late Future<Position> _positionFuture;
  LatLng? myLocation;

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("");
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final MAPBOX_ACCESS_TOKEN =
      "pk.eyJ1IjoianVsaWFuLTAyMDUiLCJhIjoiY2xnb2ZuOXgzMGg3NTNkcDlnZXdkYTU4MyJ9.OkTew7NYR5-xEVtLhROUNg";
  final MAPBOX_STYLE = "clgogdowb008p01ql86ci0i21";
  final MARKER_COLOR = ColorsTheme.redColor;

  @override
  void initState() {
    super.initState();
    _positionFuture = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.redColor,
        centerTitle: true,
        title: Text("Mapa"),
      ),
      body: FutureBuilder<Position>(
        future: _positionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show a loading indicator while waiting for the location
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }
          if (snapshot.hasError) {
            // handle any errors that occurred while getting the location
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final position = snapshot.data!;
          myLocation = LatLng(position.latitude, position.longitude);
          return FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: myLocation,
            ),
            nonRotatedLayers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/julian-0205/clgogdowb008p01ql86ci0i21/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoianVsaWFuLTAyMDUiLCJhIjoiY2xnb2ZuOXgzMGg3NTNkcDlnZXdkYTU4MyJ9.OkTew7NYR5-xEVtLhROUNg",
                additionalOptions: {
                  'mapStyleId': MAPBOX_STYLE,
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: myLocation!,
                    builder: (_) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: MARKER_COLOR, shape: BoxShape.circle),
                      );
                    },
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
