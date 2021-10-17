class Session {
  late final String token;
  late final String userUUID;

  Session(this.token, this.userUUID);

  Session.fromJson(Map<String, dynamic> data) {
    token = data['token'];
    userUUID = data['user_uuid'];
  }
}
