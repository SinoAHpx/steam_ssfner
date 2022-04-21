import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:steam_ssfner/services/dialog_utils.dart';
import 'package:steam_ssfner/services/ssfn_service.dart';
import 'package:steam_ssfner/services/win32_service.dart';
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
  var ssfnController = TextEditingController();

  var pathController = TextEditingController();

  void _writeSsfn() async {
    if (ssfnController.text.isEmpty || pathController.text.isEmpty) {
      showCannotDialog(context: context, reason: 'Required information missed');
      return;
    }

    if (!(await Directory(pathController.text).exists())) {
      showCannotDialog(
          context: context, reason: 'Invalid destination directory');
      return;
    }

    try {
      await SSFNService.write(
          ssfn: ssfnController.text, steamPath: pathController.text);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully wrote SSFN file!')));
    } on Error catch (e) {
      showFailedDialog(context: context, exception: e);
    } on Exception catch (e) {
      showFailedDialog(context: context, exception: e);
    }
  }

  void _browserSsfn() async {
    var path = await FilePicker.platform.getDirectoryPath();
    if (path == null) {
      showCannotDialog(context: context, reason: 'Invalid SSFN!');
      return;
    }

    setState(() {
      pathController.text = path!;
    });
  }

  void _resetSteamPath() {
    final path = Win32Service.getSteamPathByRegistry();
    if (path != null) {
      setState(() {
        pathController.text = path;
      });
    }
  }

  void _clearSsfn() async {
    final dialogResult = await showConfirmDialog();

    if (dialogResult) {
      if (pathController.text.isEmpty) {
        showCannotDialog(context: context, reason: 'Invalid steam path!');
        return;
      }

      final children =
          Directory(pathController.text).listSync().whereType<File>();
      for (var child in children) {
        if (child.uri.pathSegments.last.startsWith('ssfn')) {
          await child.delete();
        }
      }
    }
  }

  Future<bool> showConfirmDialog() async {
    var result = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirm'),
              content: const Text(
                  'Are you sure to clear the SSFN file? This action cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    result = true;
                  },
                ),
              ],
            ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          // style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              child: const Icon(FontAwesome5.github),
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                launch("https://github.com/SinoAHpx/steam_ssfner");
              })
        ],
        // flexibleSpace: Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Image.asset(
        //       'assets/last_sunset_2020.jpg',
        //       fit: BoxFit.cover,
        //     ),
        //     ClipRRect(
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        //         child: Container(
        //           color: Colors.transparent,
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        // backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          children: [
            ButtonSet(
              labelText: 'Steam SSFN',
              hintText: 'e.g. ssfn895090427336812694',
              textController: ssfnController,
              interactivities: [
                ElevatedButton(
                    onPressed: _writeSsfn, child: const Text('Write')),
              ],
            ),
            ButtonSet(
              labelText: 'Destination',
              hintText: '',
              textController: pathController,
              interactivities: [
                MyButton(
                    onPressed: _clearSsfn,
                    tooltip: 'Delete all ssfn files in the steam directory',
                    buttonText: 'Clear'),
                MyButton(
                    onPressed: _resetSteamPath,
                    tooltip: 'Reset to default steam directory if it exists',
                    buttonText: 'Reset'),
                MyButton(
                    onPressed: _browserSsfn,
                    tooltip: '',
                    buttonText: r'Browser'),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final void Function() onPressed;

  final String tooltip;

  final String buttonText;

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.tooltip,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: tooltip,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ));
  }
}

class ButtonSet extends StatelessWidget {
  const ButtonSet(
      {required this.hintText,
      required this.labelText,
      required this.textController,
      required this.interactivities,
      Key? key})
      : super(key: key);

  final String hintText;

  final String labelText;

  final TextEditingController textController;

  final List<Widget> interactivities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            TextField(
              controller: textController,
              decoration:
                  InputDecoration(hintText: hintText, labelText: labelText),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i in interactivities)
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: i,
                          ),
                        ),
                    ],
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
