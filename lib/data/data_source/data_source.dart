import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _questionsCollection =
    _firestore.collection('preguntas');

final CollectionReference _notificacionesCollection =
    _firestore.collection('notificaciones');

final CollectionReference _puntosCollection = _firestore.collection('puntos');

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

  static Stream<QuerySnapshot> getNotificaciones() {
    CollectionReference notificacionesCollection = _notificacionesCollection;
    return notificacionesCollection.snapshots();
  }

  static Future<QuerySnapshot> getPuntos() async {
    CollectionReference puntosCollection = _puntosCollection;

    QuerySnapshot querySnapshot = await puntosCollection.get();
    return querySnapshot;
  }

  static Future<void> eliminarNotificacion(String id) async {
    await _notificacionesCollection.doc(id).delete();
  }
}
