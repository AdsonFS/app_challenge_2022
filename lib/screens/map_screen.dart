import 'package:app_challenge/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PointMap {
  PointMap(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<PointMap> getMyPositionAsync() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return PointMap(position.latitude, position.longitude);
  }

  Future<List<Map<String, Object>>> getPositionsAsync() async {
    return <Map<String, Object>>[
      {
        'point': await getMyPositionAsync(),
        'address': 'null',
        'owner': '',
      },
      {
        'point': PointMap(-22.2464740, -45.7124227),
        'address': 'R. Cap. Vicente Ribeiro do Vale, 644',
        'owner': 'Lucas Mendes',
      },
      {
        'point': PointMap(-22.2501582, -45.7038590),
        'address': 'R. Cel. Joaquim Neto, 186',
        'owner': 'Renzo Mesquita',
      },
      {
        'point': PointMap(-22.2538855, -45.7012116),
        'address': 'R. Cel. Francisco Palma, 281',
        'owner': 'Adson Santos',
      },
      {
        'point': PointMap(-22.2552995, -45.7043577),
        'address': 'Av. Sinhá Moreira, 191',
        'owner': 'Julia Rosa'
      },
      {
        'point': PointMap(-22.2582524, -45.6923052),
        'address': 'R. Dalton Luís Teles, 160',
        'owner': 'Chacara 3 Bois'
      },
    ];
  }

  String _messageFooter = 'A Viasat selecionou os';
  String _messageFooterName = 'melhores pontos para você';
  String _messageFooterAdrress = 'Selecione um CheckPoint! :)';

  void Function(BuildContext)? _onPressed = null;

  List<Marker> buildListMarkers(List<Map<String, Object>> points) {
    Color getColor(bool myColor) => myColor ? Colors.green : Colors.purple;

    return points.map((po) {
      var p = po['point'] as PointMap;
      var address = po['address'] as String;

      return Marker(
        height: 50,
        width: 50,
        point: LatLng(p.latitude, p.longitude),
        builder: (ctx) => IconButton(
          icon: Icon(
            Icons.pin_drop,
            color: getColor(address.compareTo('null') == 0),
          ),
          iconSize: 40,
          onPressed: () {
            if (address.compareTo('null') == 0) return;
            setState(() {
              _messageFooter = 'CheckPoint Selecionado';
              _messageFooterName = 'Proprietário: ${po['owner'] as String}';
              _messageFooterAdrress = 'Endereço: ${address}';
              _onPressed = (BuildContext context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(po['owner'] as String)),
                );
              };
            });
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckPoints Compartilhados'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 189, 205, 228),
                border: Border.all(
                  color: Color.fromARGB(255, 189, 205, 228),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: FutureBuilder<List<Map<String, Object>>>(
                future: getPositionsAsync(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Carregando mapa');
                  var data = snapshot.data!;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FlutterMap(
                      options: MapOptions(
                        maxZoom: 18.00,
                        minZoom: 13.00,
                        center: LatLng((data[0]['point'] as PointMap).latitude,
                            (data[0]['point'] as PointMap).longitude),
                        zoom: 15.0,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayerOptions(
                          markers: buildListMarkers(data),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(120, 189, 205, 228),
              border: Border.all(
                color: Color.fromARGB(255, 154, 190, 240),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 47, 0, 255),
                      child: Icon(
                        Icons.wifi,
                        color: Colors.white,
                      ),
                    ),
                    const VerticalDivider(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _messageFooter,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        (_messageFooterAdrress != '')
                            ? Text(
                                _messageFooterName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : const SizedBox.shrink(),
                        (_messageFooterAdrress != '')
                            ? Text(
                                _messageFooterAdrress,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 10),
                ElevatedButton(
                  onPressed:
                      _onPressed == null ? null : () => _onPressed!(context),
                  child: const Text('Solicitar visita'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
