import 'package:co_table/models/models.dart';

abstract class RoomRepo {
  Future<String> createRoom({required String name, String? faculty});

  Future<RoomModel> getRoom();

  Future<List<RoomModel>> getAllRoom({int page = 1});

  Future<String> updateRoom(
      {required int roomId, required String name, String? faculty});

  Future<String> deleteRoom({required int roomId});
}
