import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho_flutter/model/veiculo.dart';
import 'package:trabalho_flutter/viewmodel/veiculo_viewmodel.dart';

class MeusVeiculosScreen extends ConsumerStatefulWidget {
  const MeusVeiculosScreen({super.key});

  @override
  ConsumerState<MeusVeiculosScreen> createState() => _MeusVeiculosScreenState();
}

class _MeusVeiculosScreenState extends ConsumerState<MeusVeiculosScreen> {
  void _showAddVeiculoDialog(BuildContext context) {
    final modeloController = TextEditingController();
    final marcaController = TextEditingController();
    final placaController = TextEditingController();
    final anoController = TextEditingController();
    final List<String> tiposSelecionados = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Adicionar Veículo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                TextField(
                  controller: marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                ),
                TextField(
                  controller: anoController,
                  decoration: const InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tipos de Combustível:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...['Gasolina', 'Etanol', 'Diesel', 'GNV'].map((tipo) {
                  return CheckboxListTile(
                    title: Text(tipo),
                    value: tiposSelecionados.contains(tipo),
                    onChanged: (checked) {
                      setStateDialog(() {
                        if (checked == true) {
                          tiposSelecionados.add(tipo);
                        } else {
                          tiposSelecionados.remove(tipo);
                        }
                      });
                    },
                  );
                }).toList(),
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
                if (modeloController.text.isEmpty ||
                    marcaController.text.isEmpty ||
                    placaController.text.isEmpty ||
                    anoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                if (tiposSelecionados.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Selecione pelo menos um tipo de combustível',
                      ),
                    ),
                  );
                  return;
                }

                final veiculo = Veiculo(
                  modelo: modeloController.text,
                  marca: marcaController.text,
                  placa: placaController.text,
                  ano: int.parse(anoController.text),
                  tiposCombustivel: tiposSelecionados,
                );

                try {
                  await ref
                      .read(veiculoViewModelProvider.notifier)
                      .addVeiculo(veiculo);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veículo adicionado com sucesso'),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar veículo: $e')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final veiculosAsync = ref.watch(veiculoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Meus Veículos")),
      body: veiculosAsync.when(
        data: (veiculos) {
          if (veiculos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nenhum veículo cadastrado'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddVeiculoDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Veículo'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: veiculos.length + 1, // +1 = botão no final
            itemBuilder: (context, index) {
              // Último item => botão
              if (index == veiculos.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddVeiculoDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Veículo'),
                  ),
                );
              }

              final veiculo = veiculos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car, size: 40),
                  title: Text('${veiculo.marca} ${veiculo.modelo}'),
                  subtitle: Text(
                    'Placa: ${veiculo.placa} | Ano: ${veiculo.ano}\n${veiculo.tiposCombustivel.join(", ")}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: const Text('Deseja excluir este veículo?'),
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

                      if (confirm == true && veiculo.id != null) {
                        await ref
                            .read(veiculoViewModelProvider.notifier)
                            .deleteVeiculo(veiculo.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veículo excluído')),
                          );
                        }
                      }
                    },
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
