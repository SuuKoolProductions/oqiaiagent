// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiMessageAdapter extends TypeAdapter<AiMessage> {
  @override
  final int typeId = 1;

  @override
  AiMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiMessage(
      id: fields[0] as String,
      content: fields[1] as String,
      isFromUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      userId: fields[4] as String?,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
      messageType: fields[6] as String? ?? 'text',
      suggestedActions: (fields[7] as List?)?.cast<String>(),
      karmaPoints: fields[8] as int?,
      carbonImpact: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AiMessage obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isFromUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.messageType)
      ..writeByte(7)
      ..write(obj.suggestedActions)
      ..writeByte(8)
      ..write(obj.karmaPoints)
      ..writeByte(9)
      ..write(obj.carbonImpact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}