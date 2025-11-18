import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/abastecimento.dart';
import 'package:trabalho_flutter/model/veiculo.dart';
import 'package:trabalho_flutter/viewmodel/abastecimento_viewmodel.dart';
import 'package:trabalho_flutter/viewmodel/veiculo_viewmodel.dart';

class RegistrarAbastecimentoScreen extends ConsumerWidget {
  const RegistrarAbastecimentoScreen({super.key});

  void _showAddAbastecimentoDialog(BuildContext context, WidgetRef ref, Veiculo veiculo) {
    final dataController = TextEditingController(
      text: DateTime.now().toString().split(' ')[0],
    );
    final litrosController = TextEditingController();
    final valorController = TextEditingController();
    final kmController = TextEditingController();
    final consumoController = TextEditingController();
    final observacaoController = TextEditingController();
    String tipoCombustivel = veiculo.tiposCombustivel.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('Registrar Abastecimento - ${veiculo.modelo}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    labelText: 'Data (AAAA-MM-DD)',
                    hintText: '2024-12-01',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: litrosController,
                  decoration: const InputDecoration(labelText: 'Quantidade (litros)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(labelText: 'Valor Pago (R\$)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kmController,
                  decoration: const InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: consumoController,
                  decoration: const InputDecoration(labelText: 'Consumo'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: observacaoController,
                  decoration: const InputDecoration(labelText: 'Observação (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: tipoCombustivel,
                  decoration: const InputDecoration(labelText: 'Tipo de Combustível'),
                  items: veiculo.tiposCombustivel
                      .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        tipoCombustivel = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (litrosController.text.isEmpty ||
                    valorController.text.isEmpty ||
                    kmController.text.isEmpty ||
                    consumoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
                  );
                  return;
                }

                try {
                  final abastecimento = Abastecimento(
                    data: DateTime.parse(dataController.text),
                    quantidadeLitros: double.parse(litrosController.text),
                    valorPago: double.parse(valorController.text),
                    quilometragem: double.parse(kmController.text),
                    tipoCombustivel: tipoCombustivel,
                    veiculoId: veiculo.id!,
                    consumo: double.parse(consumoController.text),
                    observacao: observacaoController.text.isEmpty ? null : observacaoController.text,
                  );

                  await ref.read(abastecimentoViewModelProvider.notifier).addAbastecimento(abastecimento);
                  
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abastecimento registrado com sucesso')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao registrar: $e')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final veiculosAsync = ref.watch(veiculoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Registrar Abastecimento")),
      body: veiculosAsync.when(
        data: (veiculos) {
          if (veiculos.isEmpty) {
            return const Center(
              child: Text('Nenhum veículo cadastrado.\nCadastre um veículo primeiro.'),
            );
          }

          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car, size: 40),
                  title: Text('${veiculo.marca} ${veiculo.modelo}'),
                  subtitle: Text('Placa: ${veiculo.placa}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green, size: 32),
                    onPressed: () => _showAddAbastecimentoDialog(context, ref, veiculo),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
