import 'package:alertapp/core/styles/color_theme.dart';
import 'package:alertapp/presentation/map/map_view.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../data/data_source/data_source.dart';

class NotficationBox extends StatelessWidget {
  final String ciudad;
  final String nombre;
  final double latitud;
  final double longitud;
  final String fecha;
  final String id;

  const NotficationBox(
      {super.key,
      required this.nombre,
      required this.ciudad,
      required this.latitud,
      required this.longitud,
      required this.fecha,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.red,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            offset: const Offset(0, 4),
            color: const Color.fromARGB(255, 198, 199, 204),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
              Text(
                fecha,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Ciudad: $ciudad',
            style: const TextStyle(
              color: ColorsTheme.pinkColor,
              fontSize: 12,
            ),
          ),
          Text(
            'Latitud: $latitud',
            style: const TextStyle(
              color: ColorsTheme.pinkColor,
              fontSize: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Longitud: $longitud',
                style: const TextStyle(
                  color: ColorsTheme.pinkColor,
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Database.eliminarNotificacion(id);
                },
                child: const Text(
                  "Eliminar notificacion",
                  style: TextStyle(
                    color: ColorsTheme.pinkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
