import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothConnection? connection;
  bool get isConnected => (connection?.isConnected ?? false);
  late Timer timer;
  String text = "0";
  String text2 = "0";
  _initConnection() async {
    BluetoothConnection conexion =
        await BluetoothConnection.toAddress('24:62:AB:E1:8A:5E');
    connection = conexion;
    //timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
    connection?.input?.listen(onDataReceived).onDone(() {});
    //});

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initConnection();

    isConnected ? print('Conectado') : print('Desconectado');
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    //timer.cancel();
    if (isConnected) {
      connection?.dispose();
      //connection = null;
    }

    super.dispose();
  }

  void onPressed(String dato) async {
    dato = dato.trim();

    if (dato.isNotEmpty) {
      try {
        connection?.output.add(Uint8List.fromList(utf8.encode("$dato\r\n")));
        await connection?.output.allSent;

        setState(() {});
      } catch (e) {
        // Ignore error, but notify state
        print('No enviado');
        print(e);
        setState(() {});
      }
    }
  }

  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    String value = ascii.decode(data).trim();

    String subValue = value.substring(0, 2);

    setState(() {
      if (subValue == "s1") {
        String restValue1 = value.substring(2, 5);
        restValue1 = restValue1.trim();
        text = restValue1;
      }
      if (subValue == "s2") {
        String restValue2 = value.substring(2, value.length);
        text2 = restValue2;
      }
    });
    print('Data incoming: $text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Envío y recepción de datos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Datos Recibidos',
            ),
            Text("Distancia: $text cm",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text("ADC: $text2",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),
            const Text("Led"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => onPressed("1"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 10,
                  ),
                  child: const Text("ON"),
                ),
                ElevatedButton(
                  onPressed: () => onPressed("0"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 10,
                  ),
                  child: const Text("OFF"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Motor"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => onPressed("2"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 14, 126),
                    foregroundColor: Colors.white,
                    elevation: 10,
                  ),
                  child: const Text("ON"),
                ),
                ElevatedButton(
                  onPressed: () => onPressed("3"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 206, 244),
                    foregroundColor: Colors.white,
                    elevation: 10,
                  ),
                  child: const Text("OFF"),
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
