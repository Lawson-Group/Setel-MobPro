import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:coba_setel/pages/confirmation_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BikeLah'),
      ),
      body: ScanPageContent(),
    );
  }
}

class ScanPageContent extends StatefulWidget {
  @override
  _ScanPageContentState createState() => _ScanPageContentState();
}

class _ScanPageContentState extends State<ScanPageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showShelterDialog());
  }

  Future<void> _showShelterDialog() async {
    String? selectedStartShelter;
    String? selectedEndShelter;
    final shelters = <String>['GKU', 'MSU', 'OPLIB', 'TULT'];

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close the dialog
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Pilih Shelter'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Shelter Awal'),
                    items: shelters.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStartShelter = newValue;
                        selectedEndShelter = null; // Reset end shelter
                      });
                    },
                    value: selectedStartShelter,
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Shelter Akhir'),
                    items: shelters
                        .where((shelter) => shelter != selectedStartShelter)
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedEndShelter = newValue;
                      });
                    },
                    value: selectedEndShelter,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Color.fromARGB(255, 163, 41, 41),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 163, 41, 41),
                    ),
                  ),
                  onPressed: () {
                    if (selectedStartShelter != null &&
                        selectedEndShelter != null) {
                      Navigator.of(context).pop();
                      _scanBarcode();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih shelter awal dan akhir'),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);

    if (barcode != "-1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(serialNumber: barcode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Scan QR\n OR',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputSerialPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 163, 41, 41),
                  ),
                ),
                child: const Text(
                  'Input Nomor Seri',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class InputSerialPage extends StatelessWidget {
  final TextEditingController _serialNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Nomor Seri'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Masukkan\nNomor Seri Kendaraan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _serialNumberController,
                decoration: InputDecoration(
                  labelText: 'Nomor Seri Kendaraan',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String serialNumber = _serialNumberController.text;
                if (serialNumber.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ConfirmationPage(serialNumber: serialNumber),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Masukkan nomor seri terlebih dahulu'),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 163, 41, 41),
                ),
              ),
              child: const Text(
                'Input Nomor Seri',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
