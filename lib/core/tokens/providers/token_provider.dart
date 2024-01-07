import 'package:bulle/core/network/http_client.dart';
import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  void getToken(String name) async {
    _token = await _getTokenFromServer(name);
    notifyListeners();
  }

  Future<String> _getTokenFromServer(String name) async {
    var context = {"identity": _generateIdentity(name), "name": name, "room": _generateRoom(name)};

    final response = await HttpClient.instance.dio.post('/tokens', data: context);

    return response.data['token'];
  }

  String _generateIdentity(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  String _generateRoom(String name) {
    return _generateIdentity(name);
  }
}
