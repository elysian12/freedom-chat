class Chat {
  final String name;
  final String id;
  String lastMessage;
  String image;
  String time;
  final bool isActive;
  List<String> users;
  Map<String, dynamic> userInfo;

  Chat(
      {this.name = '',
      this.id = '',
      this.lastMessage = '',
      this.image = '',
      this.time = '',
      this.isActive = false,
      this.users = const [],
      this.userInfo = const {}});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'lastMessage': lastMessage,
      'image': image,
      'time': time,
      'isActive': isActive,
      'id': id,
      'users': users,
      'userInfo': userInfo
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['name'] as String,
      name: map['name'] as String,
      lastMessage: map['lastMessage'] as String,
      image: map['image'] as String,
      time: map['time'] as String,
      isActive: map['isActive'] as bool,
      userInfo: map['userInfo'] as Map<String, dynamic>,
      users: List<String>.from((map['users'] as List).map((e) => e)),
    );
  }
}

List chatsData = [
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "assets/images/user.png",
    time: "3m ago",
    isActive: false,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "assets/images/user_2.png",
    time: "8m ago",
    isActive: true,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "assets/images/user_3.png",
    time: "5d ago",
    isActive: false,
  ),
  Chat(
    name: "Jacob Jones",
    lastMessage: "You’re welcome :)",
    image: "assets/images/user_4.png",
    time: "5d ago",
    isActive: true,
  ),
  Chat(
    name: "Albert Flores",
    lastMessage: "Thanks",
    image: "assets/images/user_5.png",
    time: "6d ago",
    isActive: false,
  ),
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "assets/images/user.png",
    time: "3m ago",
    isActive: false,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "assets/images/user_2.png",
    time: "8m ago",
    isActive: true,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "assets/images/user_3.png",
    time: "5d ago",
    isActive: false,
  ),
];
