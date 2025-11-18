import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/abastecimento.dart';

class AbastecimentoRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  AbastecimentoRepository(this._firestore, this.userId);

  Future<void> addAbastecimento(Abastecimento abastecimento) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('abastecimentos')
          .add(abastecimento.toMap());
    } catch (e) {
      print('Erro ao adicionar abastecimento: $e');
      rethrow;
    }
  }

  Stream<List<Abastecimento>> getAbastecimentos() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('abastecimentos')
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Abastecimento.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Abastecimento>> getAbastecimentosByVeiculo(String veiculoId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('abastecimentos')
        .where('veiculoId', isEqualTo: veiculoId)
        .orderBy('data', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Abastecimento.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteAbastecimento(String abastecimentoId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('abastecimentos')
          .doc(abastecimentoId)
          .delete();
    } catch (e) {
      print('Erro ao deletar abastecimento: $e');
      rethrow;
    }
  }
}

final abastecimentoRepositoryProvider = Provider.family<AbastecimentoRepository, String>((ref, userId) {
  return AbastecimentoRepository(FirebaseFirestore.instance, userId);
});
