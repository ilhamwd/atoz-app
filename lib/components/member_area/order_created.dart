import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api.dart';
import 'member_identity.dart';

class OrderCreated extends StatelessWidget {
  final Api api;
  final Order order;

  const OrderCreated({Key? key, required this.api, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceInIDR = "Rp " +
        NumberFormat("#,##0.00", "in-ID")
            .format(double.parse(order.price!).toInt());
    late String message;

    if (order.type == 1) {
      message =
          "${order.productName} will be shipped to :\n${order.shippingAddress}\n\nOnly after you pay.";
    } else {
      message =
          "Your mobile phone number ${order.mobileNumber} will receive $priceInIDR";
    }

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
                      "Success!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text("Order no."),
                            ),
                            Text(order.orderNo!)
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              child: Text("Total"),
                            ),
                            Text(priceInIDR)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(message, style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 40),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: InputButton(
                            value: "Pay now",
                            onTap: () =>
                                api.orderController.payPage(order.orderNo!)))
                  ]))
        ])))));
  }
}
