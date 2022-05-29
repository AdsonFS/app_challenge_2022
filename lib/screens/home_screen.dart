import 'package:app_challenge/models/point_map.dart';
import 'package:app_challenge/screens/background.dart';
import 'package:app_challenge/screens/internet_plan_screen.dart';
import 'package:app_challenge/screens/map_screen.dart';
import 'package:app_challenge/screens/search_installer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PointMap myLocation = PointMap(0, 0);

  Future<void> getMyPositionAsync() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(
        () => myLocation = PointMap(position.latitude, position.longitude));
  }

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
        leading: const Icon(Icons.spa),
      ),
      body: Stack(
        children: [
          Background(),
          const Image(image: AssetImage('img/home_image.png')),
          ListView(children: [
            Column(
              children: [
                Divider(height: 10),
                _createCard('CheckPoints Compartilhados', 'Recurso comunitário',
                    const Icon(Icons.wifi), const MapScreen()),
                _createCard(
                    'Procurar Por Plano',
                    'Encontre o melhor plano para você',
                    const Icon(Icons.library_add_check),
                    InternetPlanScreen(myLocation)),
                _createCard(
                    'Procurar Por Instalador',
                    'Procure profissionais na sua área',
                    const Icon(Icons.webhook_rounded),
                    SearchInstallerScreen(myLocation)),
              ],
            ),
          ])
        ],
      ),
    );
  }
}
