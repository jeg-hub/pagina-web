// ignore_for_file: dead_code

import 'package:flutter/material.dart';

void main() => runApp(CalculadoraBasesApp());

class CalculadoraBasesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de hazzita',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CalculadoraBasesPage(),
    );
  }
}

enum Base { binario, octal, decimal, hexadecimal }

enum Operacion { sumar, restar, multiplicar, dividir }

class CalculadoraBasesPage extends StatefulWidget {
  @override
  _CalculadoraBasesPageState createState() => _CalculadoraBasesPageState();
}

class _CalculadoraBasesPageState extends State<CalculadoraBasesPage> {
  Base _baseActual = Base.decimal;
  String _input = '';
  String _resultado = '';
  String _operador = '';
  String _numA = '';
  String _numB = '';

  List<String> get _digitos {
    switch (_baseActual) {
      case Base.binario:
        return ['0','1'];
      case Base.octal:
        return ['0','1','2','3','4','5','6','7'];
      case Base.decimal:
        return ['0','1','2','3','4','5','6','7','8','9'];
      case Base.hexadecimal:
        return ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
    }
    return ['0','1','2','3','4','5','6','7','8','9'];
  }

  int get _radix {
    switch (_baseActual) {
      case Base.binario: return 2;
      case Base.octal: return 8;
      case Base.decimal: return 10;
      case Base.hexadecimal: return 16;
    }
    return 10;
  }

  void _onDigitPress(String d) {
    setState(() {
      _input += d;
    });
  }

  void _onOperatorPress(String op) {
    setState(() {
      if (_numA.isEmpty) {
        _numA = _input;
        _operador = op;
        _input = '';
      } else if (_numA.isNotEmpty && _input.isNotEmpty) {
        _numB = _input;
        _calcular();
        _operador = op;
      }
    });
  }

  void _calcular() {
    int? a = int.tryParse(_numA, radix: _radix);
    int? b = int.tryParse(_numB, radix: _radix);
    if (a == null || b == null) return;
    int res = 0;
    switch (_operador) {
      case '+': res = a+b; break;
      case '-': res = a-b; break;
      case '×': res = a*b; break;
      case '÷': if (b!=0) res = a~/b; break;
    }
    setState(() {
      _resultado = 'Bin: ${res.toRadixString(2).toUpperCase()}\n'
                   'Oct: ${res.toRadixString(8).toUpperCase()}\n'
                   'Dec: $res\n'
                   'Hex: ${res.toRadixString(16).toUpperCase()}';
      _numA = res.toRadixString(_radix).toUpperCase();
      _input = '';
      _numB = '';
    });
  }

  void _clear() {
    setState(() {
      _input = '';
      _numA = '';
      _numB = '';
      _operador = '';
      _resultado = '';
    });
  }

  Widget _buildButton(String text, {Color? color, double? fontSize, Function()? onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        backgroundColor: color ?? const Color.fromARGB(255, 230, 235, 240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onTap,
      child: Text(text, style: TextStyle(fontSize: fontSize ?? 30, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de hazzita'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Bin', color: _baseActual==Base.binario?Colors.orange:null, onTap: ()=>setState(()=>_baseActual=Base.binario)),
                _buildButton('Oct', color: _baseActual==Base.octal?Colors.orange:null, onTap: ()=>setState(()=>_baseActual=Base.octal)),
                _buildButton('Dec', color: _baseActual==Base.decimal?Colors.orange:null, onTap: ()=>setState(()=>_baseActual=Base.decimal)),
                _buildButton('Hex', color: _baseActual==Base.hexadecimal?Colors.orange:null, onTap: ()=>setState(()=>_baseActual=Base.hexadecimal)),
              ],
            ),
            SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(_input.isEmpty?_numA:_input, style: TextStyle(fontSize: 50)),
            ),
            SizedBox(height: 6),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                children: [
                  ..._digitos.map((d)=>_buildButton(d, onTap: ()=>_onDigitPress(d))),
                  _buildButton('+', color: const Color.fromARGB(255, 187, 243, 189), onTap: ()=>_onOperatorPress('+')),
                  _buildButton('-', color: const Color.fromARGB(255, 187, 243, 189), onTap: ()=>_onOperatorPress('-')),
                  _buildButton('×', color: const Color.fromARGB(255, 187, 243, 189), onTap: ()=>_onOperatorPress('×')),
                  _buildButton('÷', color: const Color.fromARGB(255, 187, 243, 189), onTap: ()=>_onOperatorPress('÷')),
                  _buildButton('C', color: Colors.red, onTap: _clear),
                  _buildButton('=', color: Colors.orange, onTap: (){
                    if(_input.isNotEmpty){
                      _numB = _input;
                      _calcular();
                    }
                  }),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6),
              color: Colors.grey[300],
              child: Text(_resultado, style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
