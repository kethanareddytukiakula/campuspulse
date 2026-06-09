import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../domain/outing_model.dart';

class OutingService {
  final FirebaseFirestore _firestore;

  OutingService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _outingCollection => _firestore
      .collection('outings')
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (value, _) => value,
      );

  Future<OutingModel> startOuting(String userId) async {
    final DateTime startTime = DateTime.now().toUtc();
    final DateTime createdAt = startTime;

    final documentReference = await _outingCollection.add({
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': null,
      'durationMinutes': 0,
      'createdAt': Timestamp.fromDate(createdAt),
    });

    return OutingModel(
      id: documentReference.id,
      userId: userId,
      startTime: startTime,
      endTime: null,
      durationMinutes: 0,
      createdAt: createdAt,
    );
  }

  Future<OutingModel> endOuting(String outingId, DateTime endTime) async {
    final DocumentReference<Map<String, dynamic>> documentReference =
        _outingCollection.doc(outingId);
    final snapshot = await documentReference.get();

    if (!snapshot.exists) {
      throw StateError('Outing not found for id $outingId');
    }

    final outing = OutingModel.fromMap(snapshot.data()!, snapshot.id);
    final int durationMinutes = endTime.difference(outing.startTime).inMinutes;

    await documentReference.update({
      'endTime': Timestamp.fromDate(endTime.toUtc()),
      'durationMinutes': durationMinutes,
    });

    return OutingModel(
      id: outing.id,
      userId: outing.userId,
      startTime: outing.startTime,
      endTime: endTime.toUtc(),
      durationMinutes: durationMinutes,
      createdAt: outing.createdAt,
    );
  }

  Stream<List<OutingModel>> getUserOutings(String userId) {
    debugPrint('OutingService.getUserOutings() - subscribe userId=$userId');

    return _outingCollection
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
          debugPrint(
            'OutingService: snapshot for user=$userId docs=${querySnapshot.docs.length}',
          );
          final outings = querySnapshot.docs.map((doc) {
            try {
              return OutingModel.fromMap(doc.data(), doc.id);
            } catch (e, st) {
              debugPrint(
                'OutingService: failed parsing doc ${doc.id} for user=$userId: $e\n$st',
              );
              rethrow;
            }
          }).toList();

          // already ordered by startTime desc in query, but keep defensive sort
          outings.sort((a, b) => b.startTime.compareTo(a.startTime));
          return outings;
        });
  }
}
