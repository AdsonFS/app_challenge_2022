import 'dart:convert';
import 'dart:math';

import 'package:app_challenge/models/installer.dart';
import 'package:app_challenge/models/internet_plan.dart';
import 'package:app_challenge/models/point_map.dart';
import 'package:app_challenge/screens/search_installer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class InternetPlanScreen extends StatefulWidget {
  const InternetPlanScreen(this.myLocation, {super.key});

  final PointMap myLocation;

  @override
  State<InternetPlanScreen> createState() => _InternetPlanScreenState();
}

class _InternetPlanScreenState extends State<InternetPlanScreen> {
  List<InternetPlan> _internet_plans = [];
  @override
  void initState() {
    super.initState();
    fetchInterntPlans();
  }

  Future<void> fetchInterntPlans() async {
    const String url = 'https://app-challenge-api.herokuapp.com/plans';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return;
    List<dynamic> list = json.decode(response.body);
    List<InternetPlan> internet_plans = [];
    for (int i = 0; i < list.length; i++) {
      internet_plans.add(InternetPlan.fromJson(list[i]));
    }
    setState(() => _internet_plans = internet_plans);
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
          ..._internet_plans
              .map((el) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {},
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => SearchInstallerScreen(
                                      widget.myLocation,
                                      plan: '?plan=${el.id}',
                                    )),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: el.color,
                          child: const Icon(
                            Icons.wifi,
                            color: Colors.white,
                          ),
                        ),
                        title: Center(child: Text(el.isp)),
                        subtitle: Column(
                          children: [
                            Text(
                              el.description,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${el.typeOfInternet} por: R\S${el.pricePerMonth.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.speed),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Upload: ${el.uploadSpeed} MB',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    'Download: ${el.downloadSpeed} MB',
                                    style: const TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ],
                          ),
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
