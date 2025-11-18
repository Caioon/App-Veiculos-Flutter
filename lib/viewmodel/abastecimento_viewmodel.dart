import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/abastecimento.dart';
import 'package:trabalho_flutter/model/abastecimento_repository.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';

class AbastecimentoViewModel extends StreamNotifier<List<Abastecimento>> {
  @override
  Stream<List<Abastecimento>> build() {
    final user = ref.watch(authViewModelProvider).value;
    if (user == null) return Stream.value([]);

    final repo = ref.watch(abastecimentoRepositoryProvider(user.uid));
    return repo.getAbastecimentos();
  }

  Future<void> addAbastecimento(Abastecimento abastecimento) async {
    final user = ref.read(authViewModelProvider).value;
    if (user == null) return;

    final repo = ref.read(abastecimentoRepositoryProvider(user.uid));
    await repo.addAbastecimento(abastecimento);
  }

  Future<void> deleteAbastecimento(String abastecimentoId) async {
    final user = ref.read(authViewModelProvider).value;
    if (user == null) return;

    final repo = ref.read(abastecimentoRepositoryProvider(user.uid));
    await repo.deleteAbastecimento(abastecimentoId);
  }
}

final abastecimentoViewModelProvider = StreamNotifierProvider<AbastecimentoViewModel, List<Abastecimento>>(
  AbastecimentoViewModel.new,
);
