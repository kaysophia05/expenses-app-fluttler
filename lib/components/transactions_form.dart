import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adptative_text_field.dart';
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
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            //formulario com scroll para o teclado não atrapalhar a vizualização
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              AdapitativeTextField(
                  controller: titlecontroller,
                  label: 'Titulo',
                  onSubmitted: (_) => _submitForm()),
              AdapitativeTextField(
                controller: valuecontroller,
                label: 'Valor (R\$)',
                onSubmitted: (_) => _submitForm(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                  AdaptativeButton('Nova Transação', _submitForm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
