class Veiculo {
  final String? id;
  final String modelo;
  final String marca;
  final String placa;
  final int ano;
  final List<String> tiposCombustivel;

  Veiculo({
    this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tiposCombustivel,
  });

  factory Veiculo.fromMap(Map<String, dynamic> map, String id) {
    return Veiculo(
      id: id,
      modelo: map['modelo'] ?? '',
      marca: map['marca'] ?? '',
      placa: map['placa'] ?? '',
      ano: map['ano'] ?? 0,
      tiposCombustivel: List<String>.from(map['tiposCombustivel'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tiposCombustivel': tiposCombustivel,
    };
  }
}
