class VRScannedUser {
  final String uuid;
  final Map<String, bool> gameList;
  final bool payment;
  final String gametype;
  final String userName;

  VRScannedUser({
    required this.uuid,
    required this.gameList,
    required this.payment,
    required this.gametype,
    required this.userName,
  });

  factory VRScannedUser.fromJson(Map<String, dynamic> json) {
    var gameListJson = json['gameList'] as Map<String, dynamic>;
    var gameList = Map<String, bool>.from(gameListJson)
        .map((key, value) => MapEntry(key.trim(), value));
    return VRScannedUser(
        uuid: json['uuid'],
        gameList: gameList,
        payment: json['payment'],
        userName: json['name'],
        gametype: json['gameType']);
  }
}

class VRScannedUserResponse {
  final Map<String, VRScannedUser> vrscanneduserList;

  VRScannedUserResponse({
    required this.vrscanneduserList,
  });

  factory VRScannedUserResponse.fromJson(Map<String, dynamic> json) {
    var vrUserListJson = json as Map<String, dynamic>;
    var vrscanneduserList = vrUserListJson.map((key, value) {
      var vrScannedUser = VRScannedUser.fromJson(value);
      return MapEntry(vrScannedUser.uuid, vrScannedUser);
    });
    return VRScannedUserResponse(vrscanneduserList: vrscanneduserList);
  }
}
