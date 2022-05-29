import 'package:flutter/material.dart';

class SearchInstallerScreen extends StatefulWidget {
  const SearchInstallerScreen({super.key});

  @override
  State<SearchInstallerScreen> createState() => _SearchInstallerScreenState();
}

class _SearchInstallerScreenState extends State<SearchInstallerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instaladores Viasat'),
      ),
      body: null,
    );
  }
}
