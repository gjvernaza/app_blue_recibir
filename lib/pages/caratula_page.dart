import 'package:app_blue_recibir/pages/info_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Caratula extends StatelessWidget {
  const Caratula({super.key});

  @override
  Widget build(BuildContext context) {
    final orientacion = MediaQuery.of(context).orientation;
    if (orientacion == Orientation.landscape) {
      return const SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        child: _MainCaratula(),
      );
    } else {
      return const _MainCaratula();
    }
  }
}

class _MainCaratula extends StatelessWidget {
  const _MainCaratula();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'IoT y Arduino IDE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (contex) {
                    return const Information();
                  },
                ),
              );
            },
            icon: const Icon(Icons.info_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            const Text(
              'Aplicación con Bluetooth y Arduino',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 50),
            const SizedBox(
              width: 300,
              height: 200,
              child: Icon(
                Icons.bluetooth,
                size: 250,
                color: Colors.indigoAccent,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                child: const Text('Inicio'),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomePage();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
