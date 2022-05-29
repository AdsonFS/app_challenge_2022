import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.title, {super.key});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Row> _messagesChat = [];
  final myControllerTextField = TextEditingController();

  @override
  void dispose() {
    myControllerTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar visita: ${widget.title}'),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(120, 189, 205, 228),
          border: Border.all(
            color: const Color.fromARGB(255, 154, 190, 240),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text('Por favor seja gentil! :)'),
                const Text('Qualquer problema denuncia'),
                const Text('a conversa para a ViasatApp'),
                ..._messagesChat,
              ],
            ),
            TextField(
              controller: myControllerTextField,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Digite aqui...',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _messagesChat.add(
                        Row(
                          children: [
                            Spacer(flex: 1),
                            Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(120, 189, 205, 228),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 154, 190, 240),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child:
                                            Text(myControllerTextField.text)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      myControllerTextField.text = '';
                    });
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
