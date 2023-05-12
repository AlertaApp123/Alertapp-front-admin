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

  late Stream<QuerySnapshot> _puntosStream;
  late Position _position;

  @override
  void initState() {
    super.initState();
    _puntosStream = Database.getPuntos();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    _position = await cargarUbicacion();
  }

  Future<Position> cargarUbicacion() async {
    try {
      return await MyPosition.determinePosition();
    } catch (e) {
      // Manejo de error: puedes mostrar un mensaje de error o realizar alguna acción específica
      print('Error al cargar la ubicación: $e');

      // Devuelve una ubicación predeterminada
      double latitudPredeterminada = 6.2567716; // Latitud predeterminada
      double longitudPredeterminada = -75.59016945; // Longitud predeterminada

      return Position(
        latitude: latitudPredeterminada,
        longitude: longitudPredeterminada,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }
  }

  List<Marker> createMarkersFromZonas(QuerySnapshot snapshot) {
    List<Marker> markers = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      var document = snapshot.docs[i];
      var postInfo = document.data()! as Map<String, dynamic>;
      String nombre = postInfo['nombre'];
      double latitud = postInfo['latitud'];
      double longitud = postInfo['longitud'].toDouble();
      bool peligro = postInfo['peligro'];
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(latitud, longitud),
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut);
              },
              child: Icon(
                Icons.location_pin,
                color: peligro ? Colors.red : Colors.green,
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
      body: FutureBuilder<Position>(
        future: cargarUbicacion(),
        builder: (context, snapshotUbicacion) {
          if (snapshotUbicacion.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
          if (snapshotUbicacion.hasError) {
            return Center(child: Text('Error: ${snapshotUbicacion.error}'));
          }
          final position = snapshotUbicacion.data!;

          LatLng myLocation;
          if (widget.position == null) {
            myLocation = LatLng(position.latitude, position.longitude);
          } else {
            myLocation = widget.position!;
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _puntosStream,
            builder: (context, snapshotPuntos) {
              if (!snapshotPuntos.hasData) {
                return const SizedBox();
              }
              final puntosSnapshot = snapshotPuntos.data;
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
                            point: myLocation,
                            builder: (_) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: MARKER_COLOR,
                                    shape: BoxShape.circle),
                              );
                            },
                          ),
                        ],
                      ),
                      MarkerLayerOptions(
                        markers: createMarkersFromZonas(puntosSnapshot!),
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
                      itemCount: puntosSnapshot.size,
                      itemBuilder: (context, index) {
                        final zona = puntosSnapshot.docs[index].data()
                            as Map<String, dynamic>;
                        return _MapItemDetails(
                          zona: Zona(
                            id: puntosSnapshot.docs[index].id,
                            nombre: zona['nombre'],
                            latitud: zona['latitud'],
                            longitud: zona['longitud'].toDouble(),
                            peligro: zona['peligro'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
    String textoAviso;
    Color color = zona.peligro ? Colors.red : Colors.green;
    if (zona.peligro) {
      textoAviso =
          "¿Está seguro de que quiere cambiar el punto por una zona segura? Esto indicará a las personas que en esta zona ya no hay peligro.";
    } else {
      textoAviso =
          "¿Está seguro de que quiere cambiar el punto por una zona peligrosa? Use esto solo en caso de que haya habido un problema en el sistema.";
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 200),
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
                  SizedBox(height: 8),
                  Text(
                    "Latitud:",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "${zona.latitud}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 8),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: zona.peligro
                          ? Image.asset("assets/images/logo.jpg")
                          : Image.asset(
                              "assets/images/check2.png",
                              height: 100,
                            ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Cambiar estado"),
                            content: Text(textoAviso),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text("Aceptar"),
                                onPressed: () {
                                  Database.updatePeligro(
                                      zona.id, !zona.peligro);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Cambiar estado",
                      style: TextStyle(
                        color: color,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
