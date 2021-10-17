import 'package:atoz/api.dart';
import 'package:atoz/components/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/member_area/member_area.dart';
import 'models/initial_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Home()),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final Api api = Api();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    api.sharedContext = context;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: FutureBuilder(
          future: api.init(),
          builder: (context, AsyncSnapshot<InitialData?> snapshot) {
            if (snapshot.hasError) throw snapshot.error!;
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Loading...",
                      style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
                    )
                  ],
                ),
              );
            }

            api.temporaryInitialData = snapshot.data!;

            return StreamBuilder(
              stream: api.initialDataState.getStream(),
              initialData: api.temporaryInitialData,
              builder: (context, AsyncSnapshot<InitialData?> snapshot) {
                if (snapshot.hasData && snapshot.data?.email == null) {
                  return Login(
                    api: api,
                  );
                }

                return MemberArea(api: api);
              },
            );
          }),
    );
  }
}
