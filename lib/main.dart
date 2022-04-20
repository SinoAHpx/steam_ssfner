import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam SSFNer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Steam SSFN writer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              child: const Icon(FontAwesome5.github),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                launch("https://github.com/SinoAHpx");
              })
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          children: [
            ButtonSet(
              labelText: 'Steam SSFN',
              hintText: 'e.g. ssfn895090427336812694',
              buttonText: 'Write',
              buttonAction: () {},
            ),
            ButtonSet(
              labelText: 'Destination',
              hintText: '',
              buttonText: 'Browser',
              buttonAction: () {},
            ),
          ],
        )),
      ),
    );
  }
}

class ButtonSet extends StatefulWidget {
  const ButtonSet(
      {required this.hintText,
      required this.labelText,
      required this.buttonText,
      required this.buttonAction,
      Key? key})
      : super(key: key);

  final String hintText;

  final String labelText;

  final String buttonText;

  final void Function() buttonAction;

  @override
  State<StatefulWidget> createState() {
    return ButtonSetState();
  }
}

class ButtonSetState extends State<ButtonSet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: widget.hintText, labelText: widget.labelText),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      child: Text(widget.buttonText),
                      onPressed: widget.buttonAction,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
