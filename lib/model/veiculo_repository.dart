import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/veiculo.dart';

class VeiculoRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  VeiculoRepository(this._firestore, this.userId);

  Future<void> addVeiculo(Veiculo veiculo) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('veiculos')
          .add(veiculo.toMap());
    } catch (e) {
      print('Erro ao adicionar veículo: $e');
      rethrow;
    }
  }

  Stream<List<Veiculo>> getVeiculos() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('veiculos')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Veiculo.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteVeiculo(String veiculoId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('veiculos')
          .doc(veiculoId)
          .delete();
    } catch (e) {
      print('Erro ao deletar veículo: $e');
      rethrow;
    }
  }

  Future<Veiculo?> getVeiculoById(String veiculoId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('veiculos')
          .doc(veiculoId)
          .get();

      if (doc.exists) {
        return Veiculo.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar veículo: $e');
      rethrow;
    }
  }
}

final veiculoRepositoryProvider = Provider.family<VeiculoRepository, String>((ref, userId) {
  return VeiculoRepository(FirebaseFirestore.instance, userId);
});
