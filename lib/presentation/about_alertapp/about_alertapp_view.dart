import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/styles/color_theme.dart';
import '../../core/widgets/cards/question_answer_card.dart';
import '../../data/data_source/data_source.dart';

class AboutAlertappView extends StatefulWidget {
  const AboutAlertappView({Key? key}) : super(key: key);

  @override
  _AboutAlertappViewState createState() => _AboutAlertappViewState();
}

class _AboutAlertappViewState extends State<AboutAlertappView> {
  final TextEditingController _preguntaController = TextEditingController();
  final TextEditingController _respuestaController = TextEditingController();

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
            StreamBuilder<QuerySnapshot>(
              stream: Database.getQuestions(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Hubo un error en la carga. Por favor intenta nuevamente en un rato');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      var postInfo = doc.data()! as Map<String, dynamic>;

                      String answer = postInfo['respuesta'];
                      String pregunta = postInfo['pregunta'];

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: ColorsTheme.redColor,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Eliminar Pregunta"),
                                content: const Text(
                                    "¿Está seguro que desea eliminar esta pregunta?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Eliminar"),
                                    onPressed: () async {
                                      await Database.delQuestion(doc.id);
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: QuestionAnswerCard(
                            answer: answer,
                            question: pregunta,
                            id: doc.id,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              },
            ),
            const SizedBox(height: 16),
            //Textfield de pregunta
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
            //Textfield de respuesta
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
            //Boton de agregar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  final pregunta = _preguntaController.text.trim();
                  final respuesta = _respuestaController.text.trim();

                  if (pregunta.isNotEmpty && respuesta.isNotEmpty) {
                    try {
                      await Database.addQuestion(
                          pregunta: pregunta, respuesta: respuesta);
                      _preguntaController.clear();
                      _respuestaController.clear();
                      Fluttertoast.showToast(
                        msg: "Pregunta agregada correctamente.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Hubo un error al agregar la pregunta.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
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
          ],
        ),
      ),
    );
  }
}
