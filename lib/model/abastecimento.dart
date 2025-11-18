import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento {
  final String? id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final double quilometragem;
  final String tipoCombustivel;
  final String veiculoId;
  final double consumo;
  final String? observacao;

  Abastecimento({
    this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    required this.consumo,
    this.observacao,
  });

  factory Abastecimento.fromMap(Map<String, dynamic> map, String id) {
    return Abastecimento(
      id: id,
      data: (map['data'] as Timestamp).toDate(),
      quantidadeLitros: (map['quantidadeLitros'] ?? 0).toDouble(),
      valorPago: (map['valorPago'] ?? 0).toDouble(),
      quilometragem: (map['quilometragem'] ?? 0).toDouble(),
      tipoCombustivel: map['tipoCombustivel'] ?? '',
      veiculoId: map['veiculoId'] ?? '',
      consumo: (map['consumo'] ?? 0).toDouble(),
      observacao: map['observacao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': Timestamp.fromDate(data),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'consumo': consumo,
      'observacao': observacao,
    };
  }
}
