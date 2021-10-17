import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import 'member_identity.dart';

class PayOrder extends StatelessWidget {
  final Api api;
  final String orderNo;

  const PayOrder({Key? key, required this.api, required this.orderNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderNoController = TextEditingController();

    orderNoController.value = TextEditingValue(text: orderNo);

    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          MemberIdentity(api: api),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pay your order",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    InputText(
                      placeholder: "Order No.",
                      controller: orderNoController,
                    ),
                    const SizedBox(height: 20),
                    InputButton(
                      value: "Pay now",
                      onTap: () =>
                          api.orderController.pay(orderNoController.value.text),
                    )
                  ]))
        ])))));
  }
}
