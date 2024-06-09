import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba_setel/firebase_options.dart';
import 'package:coba_setel/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _profileImageUrl;
  late String _name = '';
  late String _id = '';
  late String _email = '';
  late String _role = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userProfile =
          await FirebaseFirestore.instance
              .collection('profile')
              .doc('user')
              .get();

      if (userProfile.exists) {
        setState(() {
          _name = userProfile.data()?['Nama'] ?? 'N/A';
          _id = userProfile.data()?['ID'] ?? 'N/A';
          _email = userProfile.data()?['Email'] ?? 'N/A';
          _role = userProfile.data()?['Role'] ?? 'N/A';
          _profileImageUrl = userProfile.data()?['image'];
        });
      }
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin akan keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfilePhotoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Hapus Foto'),
              onTap: () {
                _removeImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna tidak terautentikasi')),
        );
        return;
      }

      try {
        String userId = user.uid;
        String fileName = 'profile_images/$userId/profile_image.jpg';
        TaskSnapshot snapshot =
            await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('profile')
            .doc('user')
            .update({'image': downloadUrl});

        setState(() {
          _profileImage = imageFile;
          _profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image telah berhasil diupdate')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada gambar yang dipilih')),
      );
    }
  }

  void _removeImage() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = 'profile_images/$userId/profile_image.jpg';

      await FirebaseStorage.instance.ref(fileName).delete();
      await FirebaseFirestore.instance
          .collection('profile')
          .doc('user')
          .update({'image': FieldValue.delete()});

      setState(() {
        _profileImage = null;
        _profileImageUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image telah berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 41, 41),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/circle.png')
                                as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showEditProfilePhotoDialog(context);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.black,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.pencil_alt_solid,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              itemProfile('Nama', _name, Icons.person_outline),
              const SizedBox(height: 10),
              itemProfile('ID', _id, LineAwesomeIcons.id_card),
              const SizedBox(height: 10),
              itemProfile('Email', _email, Icons.mail_outline),
              const SizedBox(height: 10),
              itemProfile('Role', _role, LineAwesomeIcons.id_badge),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _showExitDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color.fromARGB(255, 163, 41, 41),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData icondata) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(56, 163, 41, 41),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icondata),
        tileColor: Colors.white,
      ),
    );
  }
}