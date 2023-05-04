import 'package:alertapp_admin/core/styles/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:alertapp_admin/core/widgets/notificationBox.dart';

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
      body: Center(
        child: Column(
          children: [
            NotficationBox(
              ciudad: "ciudad",
              latitud: 0,
              longitud: 0,
              fecha: new DateTime(2023, 02, 01),
            )
          ],
        ),
      ),
    );
  }
}
