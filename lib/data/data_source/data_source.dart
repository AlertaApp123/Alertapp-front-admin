import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _questionsCollection =
    _firestore.collection('preguntas');

final CollectionReference _notificacionesCollection =
    _firestore.collection('notificaciones');

final CollectionReference _puntosCollection = _firestore.collection('puntos');

class Database {
  static String? userUid;

  static Future<void> addQuestion(
      {required String pregunta, required String respuesta}) async {
    await _questionsCollection.add({
      'pregunta': pregunta,
      'respuesta': respuesta,
    });
  }

  static Future<void> updatePeligro(String id, bool parametro) async {
    await _puntosCollection.doc(id).update({'peligro': parametro});
  }

  static Future<void> delNotificacion(String id) async {
    await _notificacionesCollection.doc(id).delete();
  }

  static Future<void> delQuestion(String id) async {
    await _questionsCollection.doc(id).delete();
  }

  static Stream<QuerySnapshot> getNotificaciones() {
    CollectionReference notificacionesCollection = _notificacionesCollection;
    return notificacionesCollection.snapshots();
  }

  static Stream<QuerySnapshot> getPuntos() {
    CollectionReference puntosCollection = _puntosCollection;

    return puntosCollection.snapshots();
  }

  static Stream<QuerySnapshot> getQuestions() {
    CollectionReference infoQuestionsCollection = _questionsCollection;

    return infoQuestionsCollection.snapshots();
  }
}
