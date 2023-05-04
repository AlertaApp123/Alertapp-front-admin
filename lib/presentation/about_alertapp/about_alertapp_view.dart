import 'package:alertapp_admin/core/styles/color_theme.dart';
import 'package:alertapp_admin/core/widgets/cards/question_answer_card.dart';
import 'package:alertapp_admin/data/data_source/data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutAlertappView extends StatefulWidget {
  const AboutAlertappView({super.key});

  @override
  State<AboutAlertappView> createState() => _AboutAlertappViewState();
}

class _AboutAlertappViewState extends State<AboutAlertappView> {
  final _preguntaController = TextEditingController();
  final _respuestaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.redColor,
        centerTitle: true,
        title: const Text("Sobre Alertapp"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _preguntaController,
                decoration: InputDecoration(
                  hintText: 'Pregunta',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsTheme.redColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _respuestaController,
                decoration: InputDecoration(
                  hintText: 'Respuesta',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorsTheme.redColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  final pregunta = _preguntaController.text.trim();
                  final respuesta = _respuestaController.text.trim();

                  if (pregunta.isNotEmpty && respuesta.isNotEmpty) {
                    Database.addQuestion(
                        pregunta: pregunta, respuesta: respuesta);
                    _preguntaController.clear();
                    _respuestaController.clear();
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ColorsTheme.redColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: const Text(
                  'Agregar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
