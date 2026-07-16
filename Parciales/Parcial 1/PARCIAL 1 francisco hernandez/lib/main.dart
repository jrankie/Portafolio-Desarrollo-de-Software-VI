import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Pantalla1(),
        '/segunda': (context) => const Pantalla2(),
        '/tercera': (context) => const PantallaPerfil(),
      },
    );
  }
}

class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => Pantalla();
}

class Pantalla extends State<Pantalla1> {
  bool _isHomeSelected = true;
  bool _isFavoriteSelected = false;

  Widget textBuild(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Belleza Natural'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(12.0),
            width: 500.0,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
              ],
              image: const DecorationImage(
                image: AssetImage('assets/images/nat4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.black,
        title: const Text('BELLEZA NATURAL'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          textBuild(context),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 245.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.imgur.com/Zh581k1.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 245.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.imgur.com/FCEQimZ.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 10,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Explora la naturaleza y su magia'),
            ),
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.video_call_rounded, size: 30),
              SizedBox(width: 30),
              Icon(Icons.mic_off_rounded, size: 30),
              SizedBox(width: 30),
              Icon(Icons.call_end_rounded, size: 30, color: Colors.red),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                tooltip: 'Inicio',
                onPressed: () {
                  setState(() {
                    _isHomeSelected = !_isHomeSelected;
                  });
                },
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                child: Icon(_isHomeSelected ? Icons.home : Icons.home_outlined),
              ),
              FloatingActionButton(
                heroTag: "btn2",
                tooltip: 'Favorito',
                onPressed: () {
                  setState(() {
                    _isFavoriteSelected = !_isFavoriteSelected;
                  });
                },
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                child: Icon(_isFavoriteSelected ? Icons.history : Icons.history_toggle_off_outlined),
              ),
              FloatingActionButton(
                heroTag: "btn3",
                onPressed: () {
                  Navigator.pushNamed(context, '/tercera');
                },
                tooltip: 'Perfil',
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                child: const Icon(Icons.person),
              ),
              FloatingActionButton(
                heroTag: "btn4",
                tooltip: 'Siguiente pagina',
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                child: const Icon(Icons.forward),
                onPressed: () {
                  Navigator.pushNamed(context, '/segunda');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Pantalla2 extends StatelessWidget {
  const Pantalla2({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = [
      'assets/images/nat1.jpg',
      'assets/images/nat2.jpg',
      'assets/images/nat3.png',
      'assets/images/nat4.jpg',
      'assets/images/nat5.png',
    ];

    final String imagenAleatoria = imagenes[Random().nextInt(imagenes.length)];

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Pantalla 2')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(12.0),
                  width: 480.0,
                  height: 490.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                    ],
                    image: DecorationImage(
                      image: AssetImage(imagenAleatoria),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Naturaleza Impresionante',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'btnBackP2',
              child: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.lightBlueAccent, title: const Text('Perfil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/nat1.jpg'),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Francisco Hernandez',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              'Nivel: Aventurero',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Text(
              'Logros de exploración',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.terrain, color: Colors.brown),
                    title: Text('Visitaste la montaña'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                  ListTile(
                    leading: Icon(Icons.waves, color: Colors.blue),
                    title: Text('Exploraste el río'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                  ListTile(
                    leading: Icon(Icons.park, color: Colors.green),
                    title: Text('Descubriste el bosque'),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'btnBackProfile',
                    child: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}