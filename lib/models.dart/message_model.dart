class MessageModel {
  final String? user;
  final String message;
  final bool? isMe;

  MessageModel({this.user, required this.message, this.isMe});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      user: json['User'],
      message: json['Message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'User': user,
        'Message': message,
      };
}
