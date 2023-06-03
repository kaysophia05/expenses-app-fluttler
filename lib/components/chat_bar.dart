import 'package:flutter/material.dart';

//Barras do grafico
class ChartBar extends StatelessWidget {
  final String? label;
  final double? value;
  final double? percent;

  const ChartBar({
    this.label,
    this.value,
    this.percent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //alhinhamento do texto valores
        SizedBox(
          height: 20,
          child: FittedBox(
            child: Text("R\$${value!.toStringAsFixed(2)}"),
          ),
        ),
        const SizedBox(height: 5),
        //Estruturas das barrinhas de porcentagem
        SizedBox(
          height: 60,
          width: 10,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                heightFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(label!),
      ],
    );
  }
}
