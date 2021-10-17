import 'dart:convert';

import 'package:atoz/api.dart';
import 'package:atoz/controllers/controller.dart';
import 'package:atoz/models/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class UserController extends Controller {
  UserController(Api api) : super(api);

  void _storeCredential(Session decoded) {
    api.sharedPreferences
      ..setString("token", decoded.token)
      ..setString("user_uuid", decoded.userUUID);

    Navigator.of(api.sharedContext)
      ..pop()
      ..push(CupertinoPageRoute(builder: (context) {
        return const MyApp();
      }));
  }

  login(String email, String password) async {
    final response = await super.api.request(
        endpoint: "user/login",
        method: "POST",
        useAuthorization: false,
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) return null;

    final decoded = Session.fromJson(jsonDecode(response.body)['data']);

    _storeCredential(decoded);
  }

  register(
      String name, String email, String password, BuildContext context) async {
    final response = await super.api.request(
        endpoint: "user/register",
        method: "POST",
        useAuthorization: false,
        context: context,
        body: {'name': name, 'email': email, 'password': password});

    if (response.statusCode != 200) return null;

    final decoded = Session.fromJson(jsonDecode(response.body)['data']);

    Navigator.of(api.sharedContext).pop();
    _storeCredential(decoded);
  }
}
