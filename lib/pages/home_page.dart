import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:coba_setel/pages/history_page.dart';
import 'package:coba_setel/pages/info_shelter_page.dart';
import 'package:coba_setel/pages/scan_qr_page.dart';
import 'package:coba_setel/pages/shelter_details_page.dart';
import 'package:coba_setel/pages/user_profile_page.dart';
import 'package:coba_setel/pages/feedback_page.dart';

class HomePage extends StatefulWidget {
  final String? name;

  const HomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to Setel, ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: widget.name != null ? widget.name! : '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 163, 41, 41),
                          fontSize: 25),
                    ),
                    const TextSpan(
                      text: '!',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            HomePageContent(),
            InfoShelterPage(),
            ScanPage(),
            TripHistoryPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 163, 41, 41),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Shelter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Scan QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlideshow(
            indicatorColor: Colors.blue,
            onPageChanged: (value) {
              debugPrint('Page changed: $value');
            },
            autoPlayInterval: 3000,
            isLoop: true,
            children: [
              Image.asset(
                'assets/crsel-1.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/crsel-2.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/crsel-3.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Our Shelters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/info');
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color.fromARGB(255, 163, 41, 41),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('shelters_location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error fetching data');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No shelters available');
              }

              final shelters = snapshot.data!.docs;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: shelters.take(2).map((document) {
                    final data = document.data() as Map<String, dynamic>;
                    return SegmentContainer(
                      name: data['name'],
                      image: data['image'],
                      shelter: data['shelter'],
                      description: data['desc'],
                      bikesAvailable: int.tryParse(data['bike'].toString()) ?? 0,
                      scootersAvailable: int.tryParse(data['scooter'].toString()) ?? 0,
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Sepeda Tel-U (Setel) adalah sebuah platform peminjaman sepeda yang dapat digunakan di lingkungan Telkom University. Civitas kampus dapat melakukan peminjaman kendaraan berupa sepeda atau skuter dengan melakukan login menggunakan akun Single Sign-On (SSO) Telkom University.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Setel berupaya untuk menyediakan sebuah fasilitas peminjaman kendaraan alternatif ramah lingkungan yang dapat digunakan oleh civitas Telkom University untuk kebutuhan mobilitas di lingkungan kampus. Melalui Setel, civitas kampus dapat memilih jenis kendaraan yang ingin digunakan, lokasi-lokasi shelter, dan jumlah unit yang tersedia di setiap shelternya. Selain itu, civitas kampus juga dapat mengakses informasi terkait tata cara dan kebijakan peminjaman yang berlaku',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Share Your Feedback',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.star, color: Colors.orange),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1))
                ]),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackForm()),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Berikan feedback kalian di sini!',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Icon(LineAwesomeIcons.arrow_right_solid),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SegmentContainer extends StatelessWidget {
  final String name;
  final String image;
  final String shelter;
  final String description;
  final int bikesAvailable;
  final int scootersAvailable;

  const SegmentContainer({
    Key? key,
    required this.name,
    required this.image,
    required this.shelter,
    required this.description,
    required this.bikesAvailable,
    required this.scootersAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShelterDetailsPage(
              name: name,
              shelter: shelter,
              description: description,
              bikesAvailable: bikesAvailable,
              scootersAvailable: scootersAvailable,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: Image.network(
                image,
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
