import 'package:flutter/material.dart';
import 'view_02_home.dart';
import 'view_03_CRUD.dart';

class AboutDev extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Developer'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(height: 10),
          Text(
            'Fadhlan Azka',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Mahasiswa',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.facebook),
                onPressed: () {
                  // Tambahkan tautan ke profil Facebook developer
                },
              ),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  // Tambahkan tautan ke profil Twitter developer
                },
              ),
              IconButton(
                icon: Icon(Icons.phone_android),
                onPressed: () {
                  // Tambahkan tautan ke profil LinkedIn developer
                },
              ),
              // Tambahkan ikon media sosial lainnya sesuai kebutuhan
            ],
          ),
        ],
      ),
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
          } else if (index == 0) { // Index 2 adalah tombol "Notification"
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Home(), // Pindah ke halaman "Notification"
            ));
          }
        }
      ),
    );
  }
}