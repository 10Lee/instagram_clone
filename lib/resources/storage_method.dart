import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        await _storage.ref().child(childName).child(_auth.currentUser!.uid);

    TaskSnapshot taskSnapshot = await ref.putData(file);
    return await taskSnapshot.ref.getDownloadURL();
  }
}
