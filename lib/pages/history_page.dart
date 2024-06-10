import 'package:flutter/material.dart';
import 'package:coba_setel/pages/trip_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String title;
  final String date;
  final String description;

  Trip({
    required this.title,
    required this.date,
    required this.description,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Trip(
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

class Receipt {
  final String shelterAwal;
  final String shelterAkhir;
  final double duration;

  Receipt({
    required this.shelterAwal,
    required this.shelterAkhir,
    required this.duration,
  });

  factory Receipt.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Receipt(
      shelterAwal: data['shelterAwal'] ?? '',
      shelterAkhir: data['shelterAkhir'] ?? '',
      duration: double.tryParse(data['duration'].toString()) ?? 0.0,
    );
  }
}

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  _TripHistoryPageState createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  late ScrollController _scrollController;
  final List<Trip> _trips = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchTrips();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchTrips();
    }
  }

  Future<void> _fetchTrips() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('trips')
          .orderBy('date')
          .limit(15)
          .get();

      List<Trip> newTrips = snapshot.docs.map((doc) => Trip.fromFirestore(doc)).toList();

      if (mounted) {
        setState(() {
          _trips.addAll(newTrips);
          _page++;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _trips.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < _trips.length) {
            return ListTile(
              leading: const Icon(Icons.directions_bike),
              title: Text(_trips[index].title),
              subtitle: Text(_trips[index].date),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailPage(trips: _trips[index]),
                  ),
                );
              },
            );
          } else {
            return _isLoading
                ? Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : Container();
          }
        },
      ),
    );
  }
}