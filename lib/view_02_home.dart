import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'view_03_CRUD.dart';
import 'view_04_aboutdev.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GempaTerkini> gempaList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        gempaList = (jsonData['Infogempa']['gempa'] as List)
            .map((data) => GempaTerkini.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases_sharp),
            label: 'Gempa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'CRUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About Dev',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GempaScreen(),
            ));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AboutDev(),
            ));
          }
        },
      ),
      appBar: AppBar(
        title: Text('Gempa Terkini'),
      ),
      body: ListView.builder(
        itemCount: gempaList.length,
        itemBuilder: (context, index) {
          final gempa = gempaList[index];
          return ListTile(
            title: Text('Magnitude: ${gempa.magnitude}'),
            subtitle: Text('Kedalaman: ${gempa.kedalaman}'),
            onTap: () {
              // Add action on tap if needed
            },
          );
        },
      ),
    );
  }
}

class GempaTerkini {
  final String tanggal;
  final String jam;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;

  GempaTerkini({
    required this.tanggal,
    required this.jam,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
  });

  factory GempaTerkini.fromJson(Map<String, dynamic> json) {
    return GempaTerkini(
      tanggal: json['Tanggal'],
      jam: json['Jam'],
      lintang: json['Lintang'],
      bujur: json['Bujur'],
      magnitude: json['Magnitude'],
      kedalaman: json['Kedalaman'],
      wilayah: json['Wilayah'],
    );
  }
}