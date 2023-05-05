import 'package:alertapp/core/styles/color_theme.dart';
import 'package:alertapp/data/data_source/data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alertapp/core/widgets/notificationBox.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.redColor,
        centerTitle: true,
        title: Text("Notificaciones"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Database.getNotificaciones(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // Manejo de errores
            }
            // Construye los widgets basados en los datos
            //return Text('Datos: ${snapshot.data?.docs}');
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.docs.map((doc) {
                  var postInfo = doc.data()! as Map<String, dynamic>;

                  String nombre = postInfo['nombre'];
                  String ciudad = postInfo['ciudad'];
                  double latitud = postInfo['latitud'];
                  double longitud = postInfo['longitud'];
                  String fecha = postInfo['fecha'];
                  String id = doc.id;

                  return Center(
                    child: Column(
                      children: [
                        NotficationBox(
                          nombre: nombre,
                          ciudad: ciudad,
                          latitud: latitud,
                          longitud: longitud,
                          fecha: fecha,
                          id: id,
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            // Muestra un indicador de carga mientras se espera a que se resuelva el Future
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }
        },
      ),
    );
  }
}
