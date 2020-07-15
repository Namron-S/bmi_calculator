import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();
  final bmiDescController = TextEditingController();

  MyHomePage({this.title, Key key}) : super(key: key);

  void clearFields(
      {bool weight = false,
      bool height = false,
      bool bmi = false,
      bool bmiDesc = false}) {
    if (weight) weightController.text = "";
    if (height) heightController.text = "";
    if (bmi) bmiController.text = "";
    if (bmiDesc) bmiDescController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Table(
                  defaultColumnWidth: FractionColumnWidth(0.45),
                  children: <TableRow>[
                    TableRow(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Weight in kg'),
                            controller: weightController,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Height in cm'),
                          controller: heightController,
                        ),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: Colors.blueGrey,
                            onPressed: () {
                              int weight, height;
                              String weightStr = weightController.text,
                                  heightStr = heightController.text;
                              if (weightStr.isEmpty || heightStr.isEmpty) {
                                showAlertDialog(context,
                                    "Weight and Height must not be empty.");
                                clearFields(bmi: true, bmiDesc: true);
                                return;
                              }
                              weight = int.parse(weightStr);
                              height = int.parse(heightStr);

                              double bmi = calcBmi(weight, height);
                              String bmiStr =
                                  'BMI: ${bmi.toStringAsFixed(2)}'; //round bmi to two decimal digits
                              bmiController.text = bmiStr;
                              bmiDescController.text = getBmiDesc(bmi);
                            },
                            child: Text('Calculate BMI')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          onPressed: () {
                            clearFields(
                                weight: true,
                                height: true,
                                bmi: true,
                                bmiDesc: true);
                          },
                          child: Text("Clear"),
                        ),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          minLines: 2,
                          maxLines: 2,
                          enabled: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'BMI'),
                          controller: bmiController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          minLines: 2,
                          maxLines: 2,
                          enabled: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'BMI Description'),
                          controller: bmiDescController,
                        ),
                      )
                    ])
                  ],
                ))));
  }
}

double calcBmi(int weight, int height) {
  double result = -1;

  double heightInM = height / 100;
  result = weight / pow(heightInM, 2);

  return result;
}

String getBmiDesc(double bmi) {
  String desc = "xxx";

  if (bmi < 15) {
    desc = "Very severely underweight";
  } else if (bmi >= 15 && bmi < 16) {
    desc = "Severely underweight";
  } else if (bmi >= 16 && bmi < 18.5) {
    desc = "Underweight";
  } else if (bmi >= 18.5 && bmi < 25) {
    desc = "Normal";
  } else if (bmi >= 25 && bmi < 30) {
    desc = "Overweight";
  } else if (bmi >= 30 && bmi < 35) {
    desc = "Obese Class I";
  } else if (bmi >= 35 && bmi < 40) {
    desc = "Obese Class II";
  } else if (bmi >= 40) {
    desc = "Obese Class III";
  }

  return desc;
}

Future<void> showAlertDialog(BuildContext context, String msg) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Info'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
