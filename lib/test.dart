import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main () => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  late final WebSocketChannel _channel;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _channel = WebSocketChannel.connect(Uri.parse('ws://43.203.34.6:3000/ws/omok'));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Web Socket Example"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _channel.sink.add(_controller.text.toString());
          },
          child: const Icon(Icons.send),
        ),
        body: Container(
          height: 300,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              StreamBuilder(
                  stream: _channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}');
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}