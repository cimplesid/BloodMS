import 'package:bloodms/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future addUser(UserModel user) async {
    var ref = _firestore.collection("users").document(user.id);
    await ref.setData(user.toMap());
    return user;
  }

  Future getUsers() async {
    var docs = await _firestore.collection('users').getDocuments();
    return docs.documents
        .map<UserModel>((d) => UserModel.fromMap(d.data))
        .toList();
  }
}
