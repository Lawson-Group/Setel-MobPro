import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba_setel/pages/history_page.dart';

class TripDetailPage extends StatelessWidget {
  final Trip trips;

  const TripDetailPage({super.key, required this.trips});

  Future<Receipt?> fetchReceipt(String tripId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('receipts')
        .doc(tripId)
        .get();

    if (doc.exists) {
      return Receipt.fromFirestore(doc);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
      ),
      body: FutureBuilder<Receipt?>(
        future: fetchReceipt(trips.title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading receipt'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No receipt found'));
          } else {
            Receipt receipt = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    trips.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(trips.date, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text(trips.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Receipt Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Shelter Awal: ${receipt.shelterAwal}'),
                  Text('Shelter Akhir: ${receipt.shelterAkhir}'),
                  Text('Durasi: ${receipt.duration} menit'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}