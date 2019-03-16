import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SandWhich',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SandWhich?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _res = "";

  void initState() {
    super.initState();
    initModel();
  }

  initModel() async {
    _res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt",
        numThreads: 1 // defaults to 1
        );
    print("res:$_res");
  }

  @override
  void dispose() async {
    await Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_res',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
