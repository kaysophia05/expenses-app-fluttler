import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//FORMULÁRIO DE TRANSAÇÕES

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.onSubmit, {Key? key}) : super(key: key);

  //o componente filho (form) declara uma variável função q recebe 3 valores
  final void Function(String tittle, double value, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  //armazenam os valores do user nos campos de texto
  final titlecontroller = TextEditingController();
  final valuecontroller = TextEditingController();

  //armazena a data selecionada pelo user
  DateTime? _selectedDate = DateTime.now();

  //Chamado quando o formulario for submetido, obtendo os valores e convertendo para double
  _submitForm() {
    final title = titlecontroller.text;
    final value = double.tryParse(valuecontroller.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate!);
  }

  //Responsável por mostrar o seletor de datas
  _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Card para adicionar as informações
    //Card contem uma coluna para add os campos de entrada de dados
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //dois WD de imputação de texto para o titulo e valor
            TextField(
              controller: titlecontroller,
              //propiedade: quando o user submetre os valores ja no teclado, apertando "Enter"
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: valuecontroller,
              onSubmitted: (_) => _submitForm(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            //CAIXA 1
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    //CONDEIÇÃO: se o valor da data for um valor nulo, retorna o texto, se não retorna o valor da data.
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma Data selecionada'
                          : 'Data Selacionada ${DateFormat('dd/MM/y').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _datePicker,
                    child: const Text(
                      'Selecionar Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //CAIXA 2
            //card recebe uma linha ROW para add um botão, o row alxilia p/ o posicionamento
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  //Assim que o botão é clicado, a função declarada obtem os 2 valores e repassa p/ o componete pai
                  //OnSubmit passa para  _addtransaction no main, para os dados serem adicionados a lista de transações
                  onPressed: _submitForm,
                  child: const Text(
                    'Nova Transação',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
