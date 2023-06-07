import 'components/transactions_form.dart';
import 'package:flutter/material.dart';
import 'components/transactions_list.dart';
import 'models/transaction.dart';
import './components/chart.dart';
import 'dart:math';

void main() => runApp(ExpensesApp());

//Tema e o material app raiz
class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);

  final ThemeData tema = ThemeData(); //Variável que irá armazenar o tema do ap

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      //com o uso do copy, faço uma copia do tema atual do flutter e aplico alterações
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        //texttheme se trata dos temas de texto globais
        textTheme: tema.textTheme.copyWith(
          //titleLarge: É um estilo de texto personalizado que está sendo definido para um título grande.
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        //appbartheme =>  tema de texto do appbar
        appBarTheme: const AppBarTheme(
          //titleTextStyle: estilo de texto personalizado para o título do app bar
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //paramentros dos construtores recebidos corretamente
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> mytransactionsList =
      []; //crianção de uma lista <classe transaction> p/ as transações
  bool showChart = false;

//função verifica se a data da transação é dentro de um intervalo de sete dias a partir da data atual,  se for, retorna true
//Resultado é convertivo em mais uma transação recente na lista
  List<Transaction> get _myRecentTransactions {
    return mytransactionsList.where((tran) {
      return tran.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  //Função para adicionar uma nova transação a lista de transações
  _addTransaction(String newtittle, double newvalue, DateTime newdate) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: newtittle,
      value: newvalue,
      date: newdate,
    );

    setState(() {
      mytransactionsList.add(newTransaction);
    });
    //NAV chama o metodo pop() p\ Fechar o modal, assim que uma transação for submetida
    //Navigator => gerencia a navegação de telas no flutter
    Navigator.of(context).pop();
  }

  //Função para remover uma transação da lista, recebe o id como parametro
  //a condição é que o ID da transação seja igual ao ID fornecido como parâmetro.
  _removeTransaction(String id) {
    setState(() {
      mytransactionsList.removeWhere((tran) => tran.id == id);
    });
  }

//Função para criar um modal na parte inferior da tela para preencher o formulario
  _openTransactonFormModal(BuildContext context) {
    showModalBottomSheet(
        context:
            context, //context: especifica o contexto em que o modal será exibido.
        builder: (_) => TransactionForm(_addTransaction));
  }

  @override
  Widget build(BuildContext context) {
    //===========================================VARIÁVEIS======================================================
    //P\ MODO PAISAGEM
    bool landscapemode =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // A propriedade orientation de MediaQuery retorna a orientação atual da tela (retrato ou paisagem)
    // == Orientation.landscape aqui verifica se a orientação é paisagem retornando um val bool para landscape mode

    //APP BAR
    final appbar = AppBar(
      actions: [
        IconButton(
            onPressed: () => _openTransactonFormModal(context),
            icon: const Icon(Icons.add)),
      ],
      title: const Text('Despesas pessoais'),
    );
    //a aplicação da altura faz com que os componentes se adaptam melhor a diferentes tamanhos de tela
    final altura = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    //===========================================OFF-VARIÁVEIS=================================================
    return Scaffold(
      appBar: appbar,
      //singlechildScrollView = rolagem da tela
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (landscapemode) //se estiver em paisagem, o botão para exibir o gráfico é exibido
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //showchat incia com false, quando o user interage com o swith acionando o botão, onchanged recebe o novo valor bool = true
                  //showchat é atdd para true = newvalue
                  const Text('Exibir Grafico'),
                  Switch(
                    value: showChart,
                    onChanged: (bool newvalue) {
                      setState(() {
                        showChart = newvalue;
                      });
                    },
                  ),
                ],
              ),
            if (showChart || !landscapemode)
              SizedBox(
                height: altura * (landscapemode ? 0.7 : 0.3),
                child: Chart(_myRecentTransactions),
              ),
            if (!showChart || !landscapemode)
              SizedBox(
                height: altura * 0.7,
                child: TransactionsList(mytransactionsList, _removeTransaction),
              ),
          ],
        ),
      ),
      //Outro Botão para add transação
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactonFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
