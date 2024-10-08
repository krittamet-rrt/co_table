sealed class RoomEvent {}

class LoadRoomEvent extends RoomEvent {}

class CreateRoomEvent extends RoomEvent {
  final String name;
  final String? faculty;
  CreateRoomEvent({required this.name, this.faculty});
}

class GetRoomEvent extends RoomEvent {
  final int roomId;
  GetRoomEvent({required this.roomId});
}

class UpdateRoomEvent extends RoomEvent {
  final int roomId;
  final String name;
  final String? faculty;
  UpdateRoomEvent({required this.roomId, required this.name, this.faculty});
}

class DeleteRoomEvent extends RoomEvent {
  final int roomId;
  DeleteRoomEvent({required this.roomId});
}
