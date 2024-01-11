import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'view_02_home.dart';
import 'view_04_aboutdev.dart';

class LaporanGempa {
  int id;
  String kota;
  double magnitudo;
  DateTime waktu;

  LaporanGempa({
    required this.id,
    required this.kota,
    required this.magnitudo,
    required this.waktu,
  });

  factory LaporanGempa.fromJson(Map<String, dynamic> json) {
  double parseMagnitude(dynamic value) {
    if (value is int || value is double) {
      return value.toDouble();
    } else if (value is String) {
      double? parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  return LaporanGempa(
    id: json['id'] != null ? json['id'] as int : 0,
    kota: json['kota'] != null ? json['kota'] as String : '',
    magnitudo: parseMagnitude(json['magnitudo']),
    waktu: json['waktu'] != null ? DateTime.parse(json['waktu'] as String) : DateTime.now(),
  );
}



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kota': kota,
      'magnitude': magnitudo,
      'waktu': waktu.toIso8601String(),
    };
  }
}

class GempaScreen extends StatefulWidget {
  @override
  _GempaScreenState createState() => _GempaScreenState();
}

class _GempaScreenState extends State<GempaScreen> {
  // URL endpoint PHP
  final String baseUrl = 'http://192.168.56.1/flutter/api/'; //ip from ipconfig
  late List<LaporanGempa> _data;
  late LaporanGempa _newData; // Tambahkan variabel _newData

  @override
  void initState() {
    super.initState();
    _data = []; // Atur _data menjadi list kosong saat diinisialisasi
    _newData = LaporanGempa(id: 0, kota: '', magnitudo: 0.0, waktu: DateTime.now()); // Inisialisasi _newData
    _getData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> _getData() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    if (response.statusCode == 200) {
      setState(() {
        _data = (json.decode(response.body) as List)
            .map((data) => LaporanGempa.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk menambah data
  Future<void> _addData(LaporanGempa newData) async {
  final response = await http.post(
    Uri.parse('$baseUrl/create.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      'kota': newData.kota,
      'magnitudo': newData.magnitudo.toString(),
      'waktu': newData.waktu.toIso8601String(),
      // Sesuaikan dengan nama-nama field yang sesuai dengan server Anda
    },
  );
  if (response.statusCode == 200) {
    // Refresh data setelah berhasil menambahkan data baru
    _getData();
  } else {
    throw Exception('Failed to add data');
  }
}

  // Fungsi untuk menghapus data
  Future<void> _deleteData(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      body: {'id': id.toString()},
    );
    if (response.statusCode == 200) {
      // Refresh data setelah berhasil menghapus data
      _getData();
    } else {
      throw Exception('Failed to delete data');
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
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Home(),
            ));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AboutDev(),
            ));
          }
        }
      ),
      appBar: AppBar(
        title: Text('Laporan Gempa'),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          return ListTile(
            title: Text('Kota: ${item.kota}, Magnitude: ${item.magnitudo}'),
            subtitle: Text('Taktu: ${item.waktu.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteData(item.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Menampilkan dialog untuk menambahkan data baru
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tambah Data Gempa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Kota'),
                    onChanged: (value) {
                      // Ubah data kota pada objek baru
                      _newData.kota = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Magnitude'),
                    onChanged: (value) {
                      // Ubah data magnitude pada objek baru
                      _newData.magnitudo = double.parse(value);
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Reset form
                    _newData = LaporanGempa(id: 0, kota: '', magnitudo: 0.0, waktu: DateTime.now());
                    Navigator.pop(context);
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    // Tambah data baru
                    _addData(_newData);
                    Navigator.pop(context);
                  },
                  child: Text('Simpan'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}