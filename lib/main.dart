import 'package:flutter/material.dart';
import 'components/transactions_form.dart';
import 'components/transactions_list.dart';
import 'models/transaction.dart';
import './components/chart.dart';
import 'dart:math';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);
  //Variável que irá armazenar o tema do app
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      //copyWith() modifica propiedades do tema como a colorScheme, nela as cores primária e secundária são definidas
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),

        //para isso as fontes foram declaradas no pubspec
        //texttheme se trata dos temas de texto globais, como na lista
        //com o uso do copy, faço uma copia do tema atual do flutter e aplico alterações
        textTheme: tema.textTheme.copyWith(
          //titleLarge: É um estilo de texto personalizado que está sendo definido para um título grande.
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        //appbartheme se trata do tema de texto do appbar
        appBarTheme: const AppBarTheme(
          //titleTextStyle: É um estilo de texto personalizado para o título na barra de aplicativos
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
  final List<Transaction> mytransactionsList = [];

//função verifica se a data da transação é dentro de um intervalo de sete dias a partir da data atual, e se for, retorna true
//por fim, o resultado é convertivo em mais uma transação na lista
  List<Transaction> get _myRecentTransactions {
    return mytransactionsList.where((tran) {
      return tran.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  //Criação de uma função para adicionar uma nova transação a lista de transações
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
    //para fechar o modal, assim que uma transação for submetida
    //Navigator => Responsável por gerenciar a navegação de telas no flutter
    //NAV chama o metodo pop(), para fechar a tela atual e retornar à tela anterior na pilha de navegação
    Navigator.of(context).pop();
  }

//criação de uma função para remover uma transação da lista, recebe o id como parametro
//a condição é que o ID da transação seja igual ao ID fornecido como parâmetro.
  _removeTransaction(String id) {
    setState(() {
      mytransactionsList.removeWhere((tran) => tran.id == id);
    });
  }

//criação de uma função para criar um modal na parte inferior da tela para preencher o formulario
  _openTransactonFormModal(BuildContext context) {
    showModalBottomSheet(
        context:
            context, //context: especifica o contexto em que o modal será exibido.
        builder: (_) => TransactionForm(_addTransaction));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Propiedade Actions que recebe uma lista de WD, como o 'iconButton' para add botão no appbar
        actions: [
          IconButton(
              onPressed: () => _openTransactonFormModal(context),
              icon: const Icon(Icons.add)),
        ],
        title: const Text('Despesas pessoais'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_myRecentTransactions),
            TransactionsList(mytransactionsList, _removeTransaction),
          ],
        ),
      ),
      //Outro Botão para add transaçãor
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactonFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
