import 'dart:convert';

import 'package:atoz/controllers/order.dart';
import 'package:atoz/models/initial_data.dart';
import 'package:atoz/models/session.dart';
import 'package:atoz/states/initial_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/user.dart';

class Api {
  // States
  final initialDataState =
      InitialDataState(); // Only changes when login and logout
  final publicInitialDataState = InitialDataState(); // Changes everytime needed
  late InitialData temporaryInitialData;

  // Controllers
  late OrderController orderController;
  late UserController userController;

  late SharedPreferences sharedPreferences;
  late Session session;
  late BuildContext sharedContext;

  // Configs
  String defaultApi = "http://192.168.43.154:8000/";

  Api() {
    orderController = OrderController(this);
    userController = UserController(this);
  }

  showLoadingDialog() => showDialog(
      barrierDismissible: false,
      context: sharedContext,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      });

  Future<Response> request({
    String method = "GET",
    required String endpoint,
    BuildContext? context,
    Map<String, String>? headers,
    Map<String, String> body = const {},
    bool useAnimation = true,
    bool useAuthorization = true,
    bool showMessageWhenError = true,
  }) {
    final uri = Uri.parse("$defaultApi$endpoint");
    late Future<Response> requestor;

    headers ??= {};

    if (useAuthorization) {
      headers['Authorization'] = "Basic " +
          base64Encode(utf8.encode("${session.userUUID}:${session.token}"));
    }

    if (useAnimation) showLoadingDialog();

    if (method == "POST") {
      requestor = post(uri, headers: headers, body: body);
    } else {
      requestor = get(uri, headers: headers);
    }

    if (useAnimation) requestor.then((_) => Navigator.of(sharedContext).pop());

    if (useAnimation) {
      requestor.then((response) {
        if (response.statusCode != 200) {
          final decoded = jsonDecode(response.body);
          showDialog(
              context: sharedContext,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(decoded['message']),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(sharedContext),
                        child: const Text("Close"))
                  ],
                );
              });
        }
      });
    }

    return requestor;
  }

  Future<InitialData?> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final loggedIn = await isLoggedIn();

    if (loggedIn == null) sharedPreferences.clear();

    return loggedIn;
  }

  Future<InitialData?> isLoggedIn() async {
    final storedToken = sharedPreferences.getString("token"),
        storedUUID = sharedPreferences.getString("user_uuid");

    if (storedToken == null || storedUUID == null) return InitialData.empty();

    session = Session(storedToken, storedUUID);
    final initialData =
        await request(endpoint: "user/get_initial_data", useAnimation: false);

    if (initialData.statusCode == 401) return InitialData.empty();

    final initialDataInstance =
        InitialData.fromJson(jsonDecode(initialData.body)['data']);

    initialDataState.getSink().add(initialDataInstance);
    publicInitialDataState.getSink().add(initialDataInstance);

    return initialDataInstance;
  }
}
