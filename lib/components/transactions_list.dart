import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  //Declaração de uma lista <Transaction> e uma função de deletar
  // class TransactionsList: Recebe a lista vacia passada pelo main
  final List<Transaction> myTransactionsList;
  final void Function(String) onRemove;

  //Parametros a serem recebidos na classe da lista de transações principal do app
  const TransactionsList(this.myTransactionsList, this.onRemove, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Build retorna um sizebox de aviso caso nenhuma transação tenha sido add
    return SizedBox(
      height: 400,
      child: myTransactionsList.isEmpty
          //ajustando o tamanho disponivel para img com o layoutbuilder
          ? LayoutBuilder(builder: (ctx, Constraints) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma Transação Cadastrada!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: Constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          //Caso tenha transações, ele retorna os cards com cada transação
          //commo o medoto recebe a lista de transações o ListView: tem acesso aos indices da lista e a torna rolavel
          : ListView.builder(
              //LView recebe o comprimento da lista e uma função para construir cada elemento da lista
              itemCount: myTransactionsList.length,
              //recebendo o contexto o index de cada item
              itemBuilder: (ctx, index) {
                final tr = myTransactionsList[index];
                //A classe TransactionsList consegue criar os cartões das transações com base nas info de cada objeto Transaction contido na lista.
                //Card com toda a estrutura de cada cartão de despesa
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          //Valor
                          child: Text(
                            'R\$${tr.value}',
                          ),
                        ),
                      ),
                    ),
                    //Titulo
                    title: Text(
                      tr.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    //Subtitulo com Data
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                    ),
                    //Botão de Remoção
                    trailing: IconButton(
                      onPressed: () => onRemove(tr.id),
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
