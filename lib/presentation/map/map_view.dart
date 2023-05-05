import 'package:alertapp/core/styles/color_theme.dart';
import 'package:alertapp/data/data_source/data_source.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/data_source/map/mapData.dart';
import '../../data/data_source/models/zonas.dart';
import '../../data/data_source/utils/myPosition.dart';

class MapView extends StatefulWidget {
  final LatLng? position;

  const MapView({Key? key, this.position}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView>
    with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive => true;

  late Position _positionFuture;
  LatLng? myLocation;

  @override
  void initState() {
    super.initState();
  }

  Future<void> cargarDatos() async {
    await getMarkers();
    _positionFuture = await MyPosition.determinePosition();
  }

  List<Zona> zonas = [];

  Future<void> getMarkers() async {
    QuerySnapshot snapshot = await Database.getPuntos();

    snapshot.docs.forEach(
      (document) {
        var postInfo = document.data()! as Map<String, dynamic>;
        String nombre = postInfo['nombre'];
        double latitud = postInfo['latitud'];
        double longitud = postInfo['longitud'].toDouble();
        bool peligro = postInfo['peligro'];

        zonas.add(Zona(
            nombre: nombre,
            latitud: latitud,
            longitud: longitud,
            peligro: peligro));
      },
    );
  }

  List<Marker> createMarkersFromZonas() {
    List<Marker> markers = [];
    for (int i = 0; i < zonas.length; i++) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(zonas[i].latitud, zonas[i].longitud),
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut);
              },
              child: Icon(
                Icons.location_pin,
                color: zonas[i].peligro ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      );
    }
    return markers;
  }

  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.redColor,
        centerTitle: true,
        title: Text("Mapa"),
      ),
      body: FutureBuilder(
        future: cargarDatos(),
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
          final position = _positionFuture;

          if (widget.position == null) {
            myLocation = LatLng(position.latitude, position.longitude);
          } else {
            myLocation = widget.position;
          }

          return Stack(
            children: [
              FlutterMap(
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
                      ),
                    ],
                  ),
                  MarkerLayerOptions(
                    markers: createMarkersFromZonas(),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                bottom: 30,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.2,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: zonas.length,
                  itemBuilder: (context, index) {
                    final zona = zonas[index];
                    return _MapItemDetails(zona: zona);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({Key? key, required this.zona}) : super(key: key);

  final Zona zona;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: zona.peligro ? ColorsTheme.redColor : Colors.green,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    zona.nombre,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    "Latitud:",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "${zona.latitud}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "Longitud:",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "${zona.longitud}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: zona.peligro
                  ? Image.asset("assets/images/logo.jpg")
                  : Image.asset(
                      "assets/images/check2.png",
                      height: 100,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
