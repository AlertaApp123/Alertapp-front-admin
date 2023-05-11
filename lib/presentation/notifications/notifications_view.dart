import 'package:alertapp/core/styles/color_theme.dart';
import 'package:alertapp/data/data_source/data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alertapp/core/widgets/notificationBox.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.redColor,
        centerTitle: true,
        title: Text("Notificaciones"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Database.getNotificaciones(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ha ocurrido un error.'),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No hay notificaciones.'),
            );
          }
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
        },
      ),
    );
  }
}
