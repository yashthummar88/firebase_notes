import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? userUid;

  static Future<void> addItem(
      {required String description,
      required Timestamp ts,
      required isComplete}) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('1234').collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "description": description,
      "createdAt": ts,
      "complete": isComplete,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('1234').collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateStatus({
    required bool status,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('1234').collection('items').doc(docId);
    (status == true) ? status = false : status = true;
    Map<String, dynamic> data = <String, dynamic>{
      "complete": status,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection
        .doc('1234')
        .collection('items')
          ..orderBy('createdAt', descending: true);

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('1234').collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
