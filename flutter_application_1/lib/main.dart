import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/cadastrar",
    routes: {
      "/cadastrar": (context) => Cadastro(),
      "/listar": (context) => Listagem(),
    },
  ));
}

class Item {
  String nome;
  int quantidade;
  double valorUnitario;

  Item(this.nome, this.quantidade, this.valorUnitario);

  double get valorTotal => quantidade * valorUnitario;
}

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController valorUnitarioController = TextEditingController();
  String mensagemErro = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Itens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Item'),
            ),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: valorUnitarioController,
              decoration: InputDecoration(labelText: 'Valor Unitário'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final nome = nomeController.text;
                final quantidadeTexto = quantidadeController.text;
                final valorUnitarioTexto = valorUnitarioController.text;

                if (nome.isNotEmpty &&
                    quantidadeTexto.isNotEmpty &&
                    valorUnitarioTexto.isNotEmpty) {
                  final quantidade = int.tryParse(quantidadeTexto);
                  final valorUnitario = double.tryParse(valorUnitarioTexto);

                  if (quantidade != null && valorUnitario != null) {
                    final item = Item(nome, quantidade, valorUnitario);
                    Listagem.itens.add(item);
                    nomeController.clear();
                    quantidadeController.clear();
                    valorUnitarioController.clear();
                    mensagemErro = '';
                  } else {
                    if (quantidade == null && valorUnitario == null) {
                      mensagemErro =
                          'Dados inválidos. Certifique-se de que a quantidade e o valor unitário sejam números válidos.';
                    } else if (quantidade == null) {
                      mensagemErro =
                          'Dados inválidos. Certifique-se de que a quantidade seja um número válido.';
                    } else {
                      mensagemErro =
                          'Dados inválidos. Certifique-se de que o valor unitário seja um número válido.';
                    }
                  }
                } else {
                  mensagemErro = 'Preencha todos os campos.';
                }
                setState(() {});
              },
              child: Text('Cadastrar'),
            ),
            Text(
              mensagemErro,
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/listar");
              },
              child: Text('Ver Lista'),
            ),
          ],
        ),
      ),
    );
  }
}

class Listagem extends StatefulWidget {
  static List<Item> itens = [];

  @override
  _ListagemState createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  void _removerItem(Item item) {
    setState(() {
      Listagem.itens.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    double valorTotalPedido =
        Listagem.itens.fold(0.0, (acc, item) => acc + item.valorTotal);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView(
        children: [
          for (var item in Listagem.itens)
            Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                _removerItem(item);
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
              ),
              child: ListTile(
                title: Text(item.nome),
                subtitle: Text(
                  'Quantidade: ${item.quantidade} x Valor Unitário: R\$${item.valorUnitario.toStringAsFixed(2)}',
                ),
                trailing:
                    Text('Total: R\$${item.valorTotal.toStringAsFixed(2)}'),
              ),
            ),
          if (Listagem.itens.isNotEmpty) SizedBox(height: 16),
          Center(
            child: Text(
              'Total do Pedidos: R\$${valorTotalPedido.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
