class Zona {
  String id;
  String nombre;
  double latitud;
  double longitud;
  bool peligro;

  Zona(
      {required this.id,
      required this.nombre,
      required this.latitud,
      required this.longitud,
      required this.peligro});

  void atualizarEstado() {
    this.peligro = !this.peligro;
  }
}
