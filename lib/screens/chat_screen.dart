import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.title, {super.key});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar visita: ${widget.title}'),
      ),
      body: Container(
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
      ),
    );
  }
}
