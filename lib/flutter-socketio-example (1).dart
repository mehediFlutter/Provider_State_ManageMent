import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SocketIOExample(),
    );
  }
}

class SocketIOExample extends StatefulWidget {
  @override
  _SocketIOExampleState createState() => _SocketIOExampleState();
}

class _SocketIOExampleState extends State<SocketIOExample> {
  late IO.Socket socket;
  String _connectionStatus = 'Disconnected';
  String _lastMessage = '';

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    print('Initializing socket...'); // Debug print
    socket = IO.io('https://websocket.pilotbazar.xyz', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Socket connected'); // Debug print
      setState(() {
        _connectionStatus = 'Connected';
      });
    });

    socket.onConnectError((error) {
      print('Connect error: $error'); // Debug print
    });

    socket.onDisconnect((_) {
      print('Socket disconnected'); // Debug print
      setState(() {
        _connectionStatus = 'Disconnected';
      });
    });

    socket.on('newMessage', (data) {
      print('Received message: $data'); // Debug print
      setState(() {
        _lastMessage = data['message'];
      });
    });

    print('Attempting to connect...'); // Debug print
    socket.connect();
  }

  void sendMessage() {
    print('Sending message...'); // Debug print
    socket.emit('sendMessage', {'message': 'Hello from Flutter!'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Connection Status: $_connectionStatus'),
            SizedBox(height: 20),
            Text('Last Received Message: $_lastMessage'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('Disposing socket...'); // Debug print
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
