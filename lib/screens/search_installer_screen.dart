import 'dart:convert';
import 'dart:math';

import 'package:app_challenge/models/installer.dart';
import 'package:app_challenge/models/point_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class SearchInstallerScreen extends StatefulWidget {
  const SearchInstallerScreen(this.myLocation, {super.key});

  final PointMap myLocation;

  @override
  State<SearchInstallerScreen> createState() => _SearchInstallerScreenState();
}

class _SearchInstallerScreenState extends State<SearchInstallerScreen> {
  List<Installer> _installers = [];
  @override
  void initState() {
    super.initState();
    fetchInstallers();
  }

  Future<void> fetchInstallers() async {
    const String url = 'https://app-challenge-api.herokuapp.com/installers';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return;
    List<dynamic> list = json.decode(response.body);
    List<Installer> installers = [];
    for (int i = 0; i < list.length; i++) {
      installers.add(Installer.fromJson(list[i]));
    }
    setState(() => _installers = installers);
  }

  Widget _getRatingWidget(double rating) {
    return Container(
      // width: 100,
      child: RatingBar.builder(
        initialRating: rating,
        itemSize: 13,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }

  Widget _getEmotionWidget(int rating) {
    switch (rating) {
      case 0:
        return const Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
        );
      case 1:
        return const Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.redAccent,
        );
      case 2:
        return const Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
        );
      case 3:
        return const Icon(
          Icons.sentiment_satisfied,
          color: Colors.lightGreen,
        );
      case 4:
        return const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
      default:
        return const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instaladores Viasat'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
          ),
          ..._installers
              .map((el) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {},
                      child: ListTile(
                        leading: _getEmotionWidget((el.rating / 2).round()),
                        title: Text(el.name),
                        subtitle: Text('Preço: R\$: ${(_calculateDistance(
                              widget.myLocation.latitude,
                              widget.myLocation.longitude,
                              el.lat,
                              el.lng,
                            ) * el.pricePerKm).toStringAsFixed(2)}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getRatingWidget(el.rating / 2),
                            Text((el.rating / 2).toString())
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }
}
