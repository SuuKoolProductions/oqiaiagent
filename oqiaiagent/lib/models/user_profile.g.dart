// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      age: fields[3] as int?,
      location: fields[4] as String?,
      priorities: (fields[5] as List?)?.cast<String>() ?? [],
      helpAreas: (fields[6] as List?)?.cast<String>() ?? [],
      bio: fields[7] as String?,
      karmaPoints: fields[8] as int? ?? 0,
      carbonCredits: fields[9] as int? ?? 0,
      joinDate: fields[10] as DateTime?,
      healthMetrics: (fields[11] as Map?)?.cast<String, dynamic>() ?? {},
      sustainabilityMetrics: (fields[12] as Map?)?.cast<String, dynamic>() ?? {},
      badges: (fields[13] as List?)?.cast<String>() ?? [],
      aiAgentId: fields[14] as String?,
      preferences: (fields[15] as Map?)?.cast<String, dynamic>() ?? {},
      isPremium: fields[16] as bool? ?? false,
      tribeId: fields[17] as String?,
      completedChallenges: (fields[18] as List?)?.cast<String>() ?? [],
      habitStreaks: (fields[19] as Map?)?.cast<String, int>() ?? {},
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.priorities)
      ..writeByte(6)
      ..write(obj.helpAreas)
      ..writeByte(7)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.karmaPoints)
      ..writeByte(9)
      ..write(obj.carbonCredits)
      ..writeByte(10)
      ..write(obj.joinDate)
      ..writeByte(11)
      ..write(obj.healthMetrics)
      ..writeByte(12)
      ..write(obj.sustainabilityMetrics)
      ..writeByte(13)
      ..write(obj.badges)
      ..writeByte(14)
      ..write(obj.aiAgentId)
      ..writeByte(15)
      ..write(obj.preferences)
      ..writeByte(16)
      ..write(obj.isPremium)
      ..writeByte(17)
      ..write(obj.tribeId)
      ..writeByte(18)
      ..write(obj.completedChallenges)
      ..writeByte(19)
      ..write(obj.habitStreaks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}