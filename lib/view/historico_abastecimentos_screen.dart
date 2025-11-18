import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/veiculo.dart';
import 'package:trabalho_flutter/viewmodel/abastecimento_viewmodel.dart';
import 'package:trabalho_flutter/viewmodel/veiculo_viewmodel.dart';
import 'package:intl/intl.dart';

class HistoricoAbastecimentosScreen extends ConsumerWidget {
  const HistoricoAbastecimentosScreen({super.key});

  String _getVeiculoNome(List<Veiculo> veiculos, String veiculoId) {
    try {
      final veiculo = veiculos.firstWhere((v) => v.id == veiculoId);
      return '${veiculo.marca} ${veiculo.modelo}';
    } catch (e) {
      return 'Veículo desconhecido';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abastecimentosAsync = ref.watch(abastecimentoViewModelProvider);
    final veiculosAsync = ref.watch(veiculoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Histórico de Abastecimentos")),
      body: abastecimentosAsync.when(
        data: (abastecimentos) {
          if (abastecimentos.isEmpty) {
            return const Center(
              child: Text('Nenhum abastecimento registrado'),
            );
          }

          return veiculosAsync.when(
            data: (veiculos) {
              return ListView.builder(
                itemCount: abastecimentos.length,
                itemBuilder: (context, index) {
                  final abast = abastecimentos[index];
                  final dateFormat = DateFormat('dd/MM/yyyy');

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_gas_station, size: 40),
                      title: Text(_getVeiculoNome(veiculos, abast.veiculoId)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data: ${dateFormat.format(abast.data)}'),
                          Text('${abast.quantidadeLitros}L - R\$ ${abast.valorPago.toStringAsFixed(2)}'),
                          Text('KM: ${abast.quilometragem.toStringAsFixed(0)} | Consumo: ${abast.consumo}'),
                          if (abast.observacao != null && abast.observacao!.isNotEmpty)
                            Text('Obs: ${abast.observacao}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text('Deseja excluir este abastecimento?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && abast.id != null) {
                            await ref
                                .read(abastecimentoViewModelProvider.notifier)
                                .deleteAbastecimento(abast.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Abastecimento excluído')),
                              );
                            }
                          }
                        },
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Erro ao carregar veículos: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
