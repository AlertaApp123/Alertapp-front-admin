import 'package:alertapp_admin/core/styles/color_theme.dart';
import 'package:flutter/material.dart';

class NotficationBox extends StatelessWidget {
  final String ciudad;
  final double latitud;
  final double longitud;
  final DateTime fecha;

  const NotficationBox(
      {super.key,
      required this.ciudad,
      required this.latitud,
      required this.longitud,
      required this.fecha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
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
              const Text(
                'Posible derrumbe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
              Text(
                fecha.toString(),
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
              const Text(
                "Ver en el mapa",
                style: TextStyle(
                  color: ColorsTheme.pinkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
