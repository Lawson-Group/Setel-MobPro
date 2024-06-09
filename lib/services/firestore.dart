import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba_setel/models/shelter.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final CollectionReference shelters =
      FirebaseFirestore.instance.collection('shelters');

  Future<String> _getImageUrl(String imageName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('shelter_images/$imageName');
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error getting image URL: $e");
    }
  }

  Stream<List<Shelter>> getSheltersStream() {
    return shelters.snapshots().asyncMap((snapshot) async {
      return Future.wait(snapshot.docs.map((doc) async {
        Shelter shelter = Shelter.fromFirestore(doc);
        shelter.image = await _getImageUrl(shelter.image);
        return shelter;
      }).toList());
    });
  }

  Future<Shelter> getShelterById(String shelterId) async {
    try {
      DocumentSnapshot shelterSnapshot = await shelters.doc(shelterId).get();
      Shelter shelter = Shelter.fromFirestore(shelterSnapshot);
      shelter.image = await _getImageUrl(shelter.image);
      return shelter;
    } catch (e) {
      throw Exception("Error getting shelter: $e");
    }
  }

  Future<List<Shelter>> getMultipleSheltersByIds(List<String> shelterIds) async {
    try {
      List<Shelter> sheltersList = [];
      for (String id in shelterIds) {
        DocumentSnapshot shelterSnapshot = await shelters.doc(id).get();
        Shelter shelter = Shelter.fromFirestore(shelterSnapshot);
        shelter.image = await _getImageUrl(shelter.image);
        sheltersList.add(shelter);
      }
      return sheltersList;
    } catch (e) {
      throw Exception("Error getting shelters: $e");
    }
  }
}
