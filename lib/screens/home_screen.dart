import 'package:app_challenge/screens/map_screen.dart';
import 'package:app_challenge/screens/search_installer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card _createCard(String title, subtitle, Icon icon, Widget screen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: ListTile(
          leading: icon,
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viasat App'),
      ),
      body: Column(
        children: [
          _createCard('CheckPoints Compartilhados', 'Recurso comunitário',
              const Icon(Icons.wifi), const MapScreen()),
          _createCard(
              'Procurar Instalador',
              'Encontre o melhor plano para você',
              const Icon(Icons.library_add_check),
              const SearchInstallerScreen()),
          const Image(image: AssetImage('img/home_image.png')),
        ],
      ),
    );
  }
}
