import 'package:flutter/foundation.dart';
import 'package:untitled_2/models/voice_room_model.dart';
import 'package:untitled_2/services/local_storage_service.dart';

class VoiceRoomService {
  static const String _roomsKey = 'voice_rooms';
  final LocalStorageService _storage;

  VoiceRoomService(this._storage);

  Future<VoiceRoomModel?> getRoomById(String roomId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index == -1) return null;
      return rooms[index];
    } catch (e) {
      debugPrint('Error getting room by id: $e');
      return null;
    }
  }

  Future<List<VoiceRoomModel>> getAllRooms() async {
    try {
      final roomsData = await _storage.getData<List>(_roomsKey);
      if (roomsData == null) {
        final sampleRooms = _getSampleRooms();
        await _storage.setData(_roomsKey, sampleRooms.map((r) => r.toJson()).toList());
        return sampleRooms;
      }
      return roomsData.map((r) => VoiceRoomModel.fromJson(r as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting rooms: $e');
      return [];
    }
  }

  Future<VoiceRoomModel?> createRoom({
    required String name,
    required String category,
    required String language,
    required String hostId,
    required String hostName,
    int maxParticipants = 10,
    bool isPublic = true,
    String? hostNativeLanguage,
    String? learningLanguage,
  }) async {
    try {
      final rooms = await getAllRooms();
      final now = DateTime.now();
      final id = 'room_${now.millisecondsSinceEpoch}';
      final room = VoiceRoomModel(
        id: id,
        name: name,
        category: category,
        language: learningLanguage ?? language,
        hostId: hostId,
        hostName: hostName,
        participantIds: [hostId],
        speakers: [hostId],
        raisedHandIds: const [],
        maxParticipants: maxParticipants,
        isPublic: isPublic,
        createdAt: now,
        updatedAt: now,
        hostNativeLanguage: hostNativeLanguage,
        learningLanguage: learningLanguage ?? language,
      );
      rooms.insert(0, room);
      final ok = await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
      if (!ok) return null;
      debugPrint('Created room ${room.id}');
      return room;
    } catch (e) {
      debugPrint('Error creating room: $e');
      return null;
    }
  }

  Future<bool> joinRoom(String roomId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        final room = rooms[index];
        if (!room.participantIds.contains(userId) && room.participantIds.length < room.maxParticipants) {
          final updatedParticipants = [...room.participantIds, userId];
          rooms[index] = room.copyWith(participantIds: updatedParticipants, updatedAt: DateTime.now());
          await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error joining room: $e');
      return false;
    }
  }

  Future<bool> leaveRoom(String roomId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        final room = rooms[index];
        final updatedParticipants = room.participantIds.where((id) => id != userId).toList();
        final updatedSpeakers = room.speakers.where((id) => id != userId).toList();
        final updatedHands = room.raisedHandIds.where((id) => id != userId).toList();
        // If host leaves and no one remains, keep room for discovery; otherwise update
        rooms[index] = room.copyWith(
          participantIds: updatedParticipants,
          speakers: updatedSpeakers.isEmpty ? [room.hostId] : updatedSpeakers,
          raisedHandIds: updatedHands,
          updatedAt: DateTime.now(),
        );
        await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error leaving room: $e');
      return false;
    }
  }

  Future<bool> raiseHand(String roomId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index == -1) return false;
      final room = rooms[index];
      if (room.raisedHandIds.contains(userId) || room.speakers.contains(userId)) return true;
      rooms[index] = room.copyWith(
        raisedHandIds: [...room.raisedHandIds, userId],
        updatedAt: DateTime.now(),
      );
      await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
      return true;
    } catch (e) {
      debugPrint('Error raising hand: $e');
      return false;
    }
  }

  Future<bool> lowerHand(String roomId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index == -1) return false;
      final room = rooms[index];
      rooms[index] = room.copyWith(
        raisedHandIds: room.raisedHandIds.where((id) => id != userId).toList(),
        updatedAt: DateTime.now(),
      );
      await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
      return true;
    } catch (e) {
      debugPrint('Error lowering hand: $e');
      return false;
    }
  }

  Future<bool> approveSpeaker(String roomId, String hostId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index == -1) return false;
      final room = rooms[index];
      if (room.hostId != hostId) return false;
      if (!room.participantIds.contains(userId)) return false;
      final newSpeakers = {...room.speakers, userId}.toList();
      final newHands = room.raisedHandIds.where((id) => id != userId).toList();
      rooms[index] = room.copyWith(
        speakers: newSpeakers,
        raisedHandIds: newHands,
        updatedAt: DateTime.now(),
      );
      await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
      return true;
    } catch (e) {
      debugPrint('Error approving speaker: $e');
      return false;
    }
  }

  Future<bool> revokeSpeaker(String roomId, String hostId, String userId) async {
    try {
      final rooms = await getAllRooms();
      final index = rooms.indexWhere((r) => r.id == roomId);
      if (index == -1) return false;
      final room = rooms[index];
      if (room.hostId != hostId) return false;
      if (userId == room.hostId) return false; // host is always a speaker
      rooms[index] = room.copyWith(
        speakers: room.speakers.where((id) => id != userId).toList(),
        updatedAt: DateTime.now(),
      );
      await _storage.setData(_roomsKey, rooms.map((r) => r.toJson()).toList());
      return true;
    } catch (e) {
      debugPrint('Error revoking speaker: $e');
      return false;
    }
  }

  List<VoiceRoomModel> _getSampleRooms() {
    final now = DateTime.now();
    return [
      VoiceRoomModel(
        id: 'room_1',
        name: 'Spanish Beginners Corner',
        category: 'Practice',
        language: 'Spanish',
        hostId: 'user_2',
        hostName: 'Maria Garcia',
        participantIds: ['user_2', 'user_5', 'user_7'],
        speakers: const ['user_2'],
        raisedHandIds: const [],
        maxParticipants: 10,
        isPublic: true,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now,
        hostNativeLanguage: 'Spanish',
        learningLanguage: 'English',
      ),
      VoiceRoomModel(
        id: 'room_2',
        name: 'French Pronunciation Practice',
        category: 'Pronunciation',
        language: 'French',
        hostId: 'user_4',
        hostName: 'Pierre Dubois',
        participantIds: ['user_4', 'user_8'],
        speakers: const ['user_4'],
        raisedHandIds: const [],
        maxParticipants: 8,
        isPublic: true,
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now,
        hostNativeLanguage: 'French',
        learningLanguage: 'English',
      ),
      VoiceRoomModel(
        id: 'room_3',
        name: 'German Study Group',
        category: 'Study',
        language: 'German',
        hostId: 'user_5',
        hostName: 'Anna Schmidt',
        participantIds: ['user_5', 'user_9', 'user_10', 'user_11'],
        speakers: const ['user_5'],
        raisedHandIds: const [],
        maxParticipants: 12,
        isPublic: true,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now,
        hostNativeLanguage: 'German',
        learningLanguage: 'English',
      ),
      VoiceRoomModel(
        id: 'room_4',
        name: 'Japanese Casual Chat',
        category: 'Conversation',
        language: 'Japanese',
        hostId: 'user_3',
        hostName: 'Yuki Tanaka',
        participantIds: ['user_3', 'user_6'],
        speakers: const ['user_3'],
        raisedHandIds: const [],
        maxParticipants: 6,
        isPublic: true,
        createdAt: now.subtract(const Duration(minutes: 45)),
        updatedAt: now,
        hostNativeLanguage: 'Japanese',
        learningLanguage: 'English',
      ),
    ];
  }
}
