import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String id;

  User(
      {@required this.name,
      @required this.email,
      @required this.phone,
      @required this.id});

  User.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key,
        name = snapshot.value['fullName'],
        email = snapshot.value['email'],
        phone = snapshot.value['phone'];
}
