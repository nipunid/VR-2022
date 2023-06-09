import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:vr_app_2022/models/vr_user_model.dart';
import '../application_state.dart';

class AssignScannedUserGames {
  final Map<String, bool> gameList;
  final String uuId;
  final String username;

  AssignScannedUserGames(this.gameList, this.uuId, this.username);
}
