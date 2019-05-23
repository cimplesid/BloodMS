import 'package:bloodms/model/user_model.dart';
import 'package:bloodms/resources/firebase_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future addUser(UserModel user) async {
    var ref = _firestore.collection("users").document(user.id);
    await ref.setData(user.toMap());
    return user;
  }

  void delete() async {
    var user = await FirebaseAuthProvider().getCurrentUser();

    _firestore.collection('users').document(user.uid).delete();
  }

  Future getUsers({bloodGroup}) async {
    var docs;
    if (bloodGroup != "All") {
      docs = await _firestore
          .collection('users')
          .where("blood", isEqualTo: bloodGroup)
          .getDocuments();
    } else {
      docs = await _firestore.collection('users').getDocuments();
    }
    return docs.documents
        .map<UserModel>((d) => UserModel.fromMap(d.data))
        .toList();
  }

  Future getUser() async {
    var user = await FirebaseAuthProvider().getCurrentUser();
    var doc = await _firestore.collection('users').document(user.uid).get();
    return UserModel.fromMap(doc.data);
  }

  Future<void> updateUser( UserModel user) async {
    var userr = await FirebaseAuthProvider().getCurrentUser();

    return await _firestore
        .collection('users')
        .document(userr.uid)
        .setData(user.toMap(), merge: true);
  }
}
