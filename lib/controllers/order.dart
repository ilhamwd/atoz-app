import 'dart:convert';

import 'package:atoz/api.dart';
import 'package:atoz/components/member_area/order_created.dart';
import 'package:atoz/components/member_area/pay_order.dart';
import 'package:atoz/controllers/controller.dart';
import 'package:atoz/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderController extends Controller {
  OrderController(Api api) : super(api);

  order(String type, String price,
      {String? productName,
      String? shippingAddress,
      String? mobileNumber}) async {
    late Map<String, String> body;

    if (type == "product") {
      body = {
        'product_name': productName!,
        'shipping_address': shippingAddress!
      };
    } else {
      body = {
        'mobile_number': mobileNumber!,
      };
    }

    body['price'] = price.toString();
    body['type'] = type;

    final response = await super
        .api
        .request(endpoint: "order/make_order", method: "POST", body: body);
    final decoded = Order.fromJson(jsonDecode(response.body)['data']);

    Navigator.pop(api.sharedContext);
    Navigator.push(api.sharedContext, CupertinoPageRoute(builder: (context) {
      return OrderCreated(api: api, order: decoded);
    }));
  }

  orderProduct(String productName, String shippingAddress, String price) {
    final intPrice = int.parse(price);

    order("product", (intPrice + 10000).toString(),
        productName: productName, shippingAddress: shippingAddress);
  }

  orderBalance(String mobileNumber, String price) {
    final intPrice = int.parse(price);

    order("balance", (intPrice + (intPrice * .05)).toString(),
        mobileNumber: mobileNumber);
  }

  payPage(String orderNo) {
    Navigator.of(api.sharedContext).push(CupertinoPageRoute(builder: (context) {
      return PayOrder(api: api, orderNo: orderNo);
    }));
  }

  pay(String orderNo) async {
    final response = await super.api.request(
        endpoint: "order/pay_order",
        method: "POST",
        body: {'order_no': orderNo});
    final decode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.popUntil(api.sharedContext, (route) => route.isFirst);
      showDialog(
          context: api.sharedContext,
          builder: (context) {
            return AlertDialog(
              content: Text(decode['message']),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(api.sharedContext),
                    child: const Text("Close"))
              ],
            );
          });
    }
  }
}
