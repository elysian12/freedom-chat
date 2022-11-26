class UserModel {
  final String name;
  final String profilePic;
  final String phoneNumber;
  final String uid;
  final bool isOnline;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.phoneNumber,
    required this.uid,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      uid: map['uid'] as String,
      isOnline: map['isOnline'] as bool,
    );
  }
}
