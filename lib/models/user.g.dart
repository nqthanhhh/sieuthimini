// GENERATED MANUAL ADAPTER
part of 'user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return User(
      email: fields[0] as String,
      password: fields[1] as String,
      role: fields[2] as String,
      fullName: fields[3] as String? ?? '',
      birthYear: fields[4] as int? ?? 0,
      phone: fields[5] as String? ?? '',
      address: fields[6] as String? ?? '',
      gender: fields[7] as String? ?? '',
      startDate: fields[8] as DateTime?,
      avatarPath: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.birthYear)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.avatarPath);
  }
}
