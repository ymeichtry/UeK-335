import 'package:flutter/material.dart';
import 'package:hello_http/request.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello HTTP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hello HTTP Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRequesting = false;
  bool _hadRequestError = true;
  final RequestManager _requestManager = RequestManager();

  // response data
  CustomResponseData? _response;

  Future<void> _createRequest() async {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values. If we changed
    // a value without calling setState(), then the build method would not be
    // called again, and so nothing would appear to happen.
    setState(() => _isRequesting = true);

    try {
      final CustomResponseData data = await _requestManager.fetchResponse();
      _response = data;
    } catch (e) {
      debugPrint('There was an exception thrown $e');

      _hadRequestError = true;
    } finally {
      // The finally block is always called after either of the blocks above (try or catch) is executed
      // so we use this one to set the actual state and notify flutter about a change in the state
      // so it rebuilds the UI
      setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: !_hadRequestError,
                child: const Text('There was an error in the request',
                    style: TextStyle(color: Colors.red))),
            Visibility(
                visible: !_isRequesting,
                child: const Text(
                    'Hit the send button below to create a request')),
            Visibility(
                visible: _isRequesting,
                child: const CircularProgressIndicator(
                  value: null,
                  semanticsLabel: 'Circular progress indicator',
                )),
            Visibility(
                visible: _response != null && !_isRequesting,
                child: Text(
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                    '\nResponse: ${_response?.deviceName} at ${_response?.date}'))
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _createRequest,
        tooltip: 'Create request',
        child: const Icon(Icons.send_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
