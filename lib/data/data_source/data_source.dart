import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _questionsCollection =
    _firestore.collection('preguntas');

class Database {
  static String? userUid;

  static Future<QuerySnapshot> getQuestions() async {
    CollectionReference infoQuestionsCollection = _questionsCollection;

    QuerySnapshot querySnapshot = await infoQuestionsCollection.get();
    return querySnapshot;
  }

  static Future<void> addQuestion(
      {required String pregunta, required String respuesta}) async {
    await _questionsCollection.add({
      'pregunta': pregunta,
      'respuesta': respuesta,
    });
  }
}
