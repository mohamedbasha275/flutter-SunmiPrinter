import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sunmi Printer',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    super.initState();

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sunmi printer Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text("Print binded: " + printBinded.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Paper size: " + paperSize.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Serial number: " + serialNumber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Printer version: " + printerVersion),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            String url =
                                'https://avatars.githubusercontent.com/u/14101776?s=100';
                            // convert image to Uint8List format
                            Uint8List byte =
                            (await NetworkAssetBundle(Uri.parse(url)).load(url))
                                .buffer
                                .asUint8List();

                            await SunmiPrinter.initPrinter();
                            await SunmiPrinter.startTransactionPrint(true);
                            await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                            await SunmiPrinter.line();
                            await SunmiPrinter.printText('Payment receipt');

                            await SunmiPrinter.printImage(byte);
                            await SunmiPrinter.lineWrap(1);
                            await SunmiPrinter.printText(
                                'Using the old way to oo!');
                            await SunmiPrinter.line();

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Name',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: 'Qty',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: 'UN',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: 'TOT',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Fries',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '4x',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: '3.00',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: '12.00',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Strawberry',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '1x',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: '24.44',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: '24.44',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Soda',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '1x',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: '1.99',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: '1.99',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.line();
                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'TOTAL',
                                  width: 25,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '38.43',
                                  width: 5,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'ARABIC TEXT',
                                  width: 15,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: 'اسم المشترك',
                                  width: 20,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);


                            await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                            await SunmiPrinter.line();
                            await SunmiPrinter.bold();
                            await SunmiPrinter.lineWrap(2);
                            await SunmiPrinter.exitTransactionPrint(true);
                          },
                          child: const Text('Card Example')),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                    ]),
              ),
            ],
          ),
        ));
  }
}

Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer
      .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}

Future<Uint8List> _getImageFromAsset(String iconPath) async {
  return await readFileBytes(iconPath);
}
