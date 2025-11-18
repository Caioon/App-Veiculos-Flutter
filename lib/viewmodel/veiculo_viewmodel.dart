import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/veiculo.dart';
import 'package:trabalho_flutter/model/veiculo_repository.dart';
import 'package:trabalho_flutter/viewmodel/auth_viewmodel.dart';

class VeiculoViewModel extends StreamNotifier<List<Veiculo>> {
  @override
  Stream<List<Veiculo>> build() {
    final user = ref.read(authViewModelProvider).value;
    if (user == null) return Stream.value([]);

    final repo = ref.read(veiculoRepositoryProvider(user.uid));
    return repo.getVeiculos();
  }

  Future<void> addVeiculo(Veiculo veiculo) async {
    final user = ref.read(authViewModelProvider).value;
    if (user == null) return;

    final repo = ref.read(veiculoRepositoryProvider(user.uid));
    await repo.addVeiculo(veiculo);
  }

  Future<void> deleteVeiculo(String veiculoId) async {
    final user = ref.read(authViewModelProvider).value;
    if (user == null) return;

    final repo = ref.read(veiculoRepositoryProvider(user.uid));
    await repo.deleteVeiculo(veiculoId);
  }
}


final veiculoViewModelProvider = StreamNotifierProvider<VeiculoViewModel, List<Veiculo>>(
  VeiculoViewModel.new,
);
