import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoShelterPage extends StatefulWidget {
  const InfoShelterPage({Key? key});

  @override
  State<InfoShelterPage> createState() => _InfoShelterPageState();
}

class _InfoShelterPageState extends State<InfoShelterPage> {
  List<QueryDocumentSnapshot> sepedaList = [];
  List<QueryDocumentSnapshot> sekuterList = [];
  Map<String, List<QueryDocumentSnapshot>> shelterSepedaMap = {};
  Map<String, List<QueryDocumentSnapshot>> shelterSekuterMap = {};

  @override
  void initState() {
    super.initState();
    fetchKendaraan();
  }

  void fetchKendaraan() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('kendaraan').get();
    setState(() {
      sepedaList = snapshot.docs
          .where((doc) => doc['jenisKendaraan'] == 'Sepeda')
          .toList();
      sekuterList = snapshot.docs
          .where((doc) => doc['jenisKendaraan'] == 'Sekuter')
          .toList();

      for (var sepeda in sepedaList) {
        final shelterId = sepeda['shelter_id'];
        if (!shelterSepedaMap.containsKey(shelterId)) {
          shelterSepedaMap[shelterId] = [];
        }
        shelterSepedaMap[shelterId]!.add(sepeda);
      }

      for (var sekuter in sekuterList) {
        final shelterId = sekuter['shelter_id'];
        if (!shelterSekuterMap.containsKey(shelterId)) {
          shelterSekuterMap[shelterId] = [];
        }
        shelterSekuterMap[shelterId]!.add(sekuter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setel',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 163, 41, 41),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Informasi Shelter',
              style: TextStyle(color: Colors.white)),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('shelters_location')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error fetching data');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data =
                    documents[index].data() as Map<String, dynamic>;
                final shelterId = documents[index].id;
                final sepedaCount =
                    shelterSepedaMap[shelterId]?.length.toString() ?? '0';
                final sekuterCount =
                    shelterSekuterMap[shelterId]?.length.toString() ?? '0';

                return ItemWidget(
                    shelter: data['shelter'],
                    image: data['image'],
                    bike: sepedaCount,
                    scooter: sekuterCount);
              },
            );
          },
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.shelter,
    required this.image,
    required this.bike,
    required this.scooter,
  }) : super(key: key);

  final String shelter;
  final String image;
  final String bike;
  final String scooter;

  @override
  Widget build(BuildContext context) {
    String selectedShelter = shelter;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 163, 41, 41)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                shelter,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                width: 200,
                height: 200,
              ),
            ),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(56, 163, 41, 41),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.electric_bike),
                          const SizedBox(width: 10),
                          Text('Tersedia $bike unit'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(56, 163, 41, 41),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.electric_scooter),
                          const SizedBox(width: 10),
                          Text('Tersedia $scooter unit'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showDialog(context, selectedShelter);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 163, 41, 41)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text('Pinjam',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String selectedShelter) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Shelter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  initialValue: selectedShelter,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Shelter Awal',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 163, 41, 41)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('shelters_location')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error fetching data');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      value: selectedShelter,
                      isExpanded: true,
                      isDense: true,
                      items: documents.map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document['shelter'] as String?,
                          child: Text(document['shelter'] as String? ?? ''),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedShelter = newValue ?? '';
                      },
                      decoration: const InputDecoration(
                        labelText: 'Shelter Tujuan',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 163, 41, 41)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 163, 41, 41)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text('Kembali'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 163, 41, 41)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text('Pilih'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
