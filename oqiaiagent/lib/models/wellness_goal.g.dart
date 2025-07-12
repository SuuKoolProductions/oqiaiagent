// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WellnessGoalAdapter extends TypeAdapter<WellnessGoal> {
  @override
  final int typeId = 2;

  @override
  WellnessGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WellnessGoal(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      createdAt: fields[4] as DateTime,
      targetDate: fields[5] as DateTime?,
      isCompleted: fields[6] as bool? ?? false,
      progress: fields[7] as int? ?? 0,
      userId: fields[8] as String?,
      milestones: (fields[9] as List?)?.cast<String>() ?? [],
      metrics: (fields[10] as Map?)?.cast<String, dynamic>() ?? {},
      karmaPointsReward: fields[11] as int? ?? 0,
      carbonCreditsReward: fields[12] as int? ?? 0,
      aiAgentId: fields[13] as String?,
      tags: (fields[14] as List?)?.cast<String>() ?? [],
      difficulty: fields[15] as String? ?? 'beginner',
      customData: (fields[16] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, WellnessGoal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.targetDate)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.progress)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.milestones)
      ..writeByte(10)
      ..write(obj.metrics)
      ..writeByte(11)
      ..write(obj.karmaPointsReward)
      ..writeByte(12)
      ..write(obj.carbonCreditsReward)
      ..writeByte(13)
      ..write(obj.aiAgentId)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.difficulty)
      ..writeByte(16)
      ..write(obj.customData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}