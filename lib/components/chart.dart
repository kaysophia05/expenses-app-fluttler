import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chat_bar.dart';

class Chart extends StatelessWidget {
  //Chart Também recebe uma lista com as informação do obj <Transaction>
  const Chart(this.recentsTransactions, {Key? key}) : super(key: key);
  final List<Transaction> recentsTransactions;

  List<Map<String, Object>> get groupedTransaction {
    //List.generate para criar uma lista de tamanho 7, onde cada elemento representa um dia da semana.
    //Os elementos representando os 7 dias anteriores à data atual, na ordem em que foram gerados = lista dos recentes
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      //colocando o valor de uma transação no dia correspondente no grafico
      double totalSum = 0.0;

      //Laço for para  percorrer a lista e calcular o valor total gasto em cada
      for (var i = 0; i < recentsTransactions.length; i++) {
        bool sameDay = recentsTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentsTransactions[i].date.month == weekDay.month;
        bool sameYear = recentsTransactions[i].date.year == weekDay.year;
        //se as data forem compativeis add o valor da transação do dia no grafico
        if (sameDay && sameMonth && sameYear) {
          totalSum += recentsTransactions[i].value;
        }
      }

      //o mapa retorna as informações sobre o dia da semana e o valor total gasto nesse dia no grafico
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  //Função para calcular o valor total de gastos na semana
  // utiliza o método fold para percorrer e acumular todos os valores da lista grouped
  // a cada interação 'sum' é acumulado com oo valor da transação atual 'tran['value]'
  double get _weekTotalValue {
    return groupedTransaction.fold(0.0, (sum, tran) {
      return sum + (tran['value'] as num);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((tran) {
            //o map será executado 7 vezes, gerando 7 barrinhas no gráfico correspondentes aos 7 dias da semana.
            return Flexible(
              //cada charbar tem o mesmo espaçamento
              fit: FlexFit.tight,
              //para cada dia cria um chartbar
              child: ChartBar(
                label: tran["day"] as String,
                value: tran['value'] as double,
                //o valor gasto em uma dia / pelo valor gasto na semana inteira = percentual de gastos diarios
                percent: _weekTotalValue == 0
                    ? 0
                    : (tran['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
