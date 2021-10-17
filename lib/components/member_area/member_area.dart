import 'package:atoz/api.dart';
import 'package:atoz/components/member_area/member_identity.dart';
import 'package:flutter/material.dart';

class MemberArea extends StatelessWidget {
  final Api api;

  const MemberArea({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MemberIdentity(api: api),
    ]);
  }
}
