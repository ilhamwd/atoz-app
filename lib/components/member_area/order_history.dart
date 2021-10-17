import 'dart:async';
import 'dart:convert';

import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:atoz/components/reuseable/pagination.dart';
import 'package:atoz/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api.dart';
import 'member_identity.dart';

class OrderHistory extends StatefulWidget {
  final Api api;

  const OrderHistory({Key? key, required this.api}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Order>? data;
  List<Order> searchResult = [];
  bool isSearching = false;
  final _displayedDataStream = StreamController<List<Order>>();
  final _moneyIDR = NumberFormat("#,##0.00", "in-ID");

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      final List<Order> tempData = [];
      widget.api
          .request(endpoint: "user/get_orders", useAnimation: false)
          .then((value) {
        final List<dynamic> raw = jsonDecode(value.body)['data'];

        for (var element in raw) {
          tempData.add(Order.fromJson(element));
        }

        setState(() {
          data = tempData;
        });
      });

      return Container();
    }

    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberIdentity(api: widget.api),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order history",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  InputText(
                    placeholder: "Search by Order No.",
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      searchResult.clear();
                      for (var element in data!) {
                        if (element.orderNo!.contains(val!)) {
                          searchResult.add(element);
                        }
                      }

                      setState(() {
                        isSearching = val!.isNotEmpty;
                      });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
                stream: _displayedDataStream.stream,
                initialData: <Order>[],
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  return Column(
                    children: snapshot.data!.map((e) {
                      final price =
                          "Rp " + _moneyIDR.format(int.parse(e.price!));
                      late Widget action;
                      late String message;

                      if (e.type == 1) {
                        message = "${e.productName} that costs $price";
                      } else {
                        message = "$price for ${e.mobileNumber}";
                      }

                      if (e.status == 0) {
                        action = InputButton(
                          value: "Pay now",
                          small: true,
                          onTap: () =>
                              widget.api.orderController.payPage(e.orderNo!),
                        );
                      } else if (e.status == 1) {
                        action = const Text("Success",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green));
                      } else if (e.status == 2) {
                        action = const Text("Canceled",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red));
                      } else if (e.status == 3) {
                        action = const Text("Failed",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red));
                      }

                      if (e.status == 1 && e.type == 1) {
                        action = Text(
                            "shipping code\n${e.shippingCode!.toUpperCase()}",
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold));
                      }

                      return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Color(0xFFDDDDDD), width: .5))),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Expanded(child: Text(e.orderNo!)),
                                          Text(price),
                                        ]),
                                        const SizedBox(height: 15),
                                        Text(message,
                                            style: const TextStyle(
                                                height: 1.8,
                                                fontWeight: FontWeight.bold)),
                                      ])),
                              const SizedBox(width: 15),
                              Flexible(child: Center(child: action)),
                            ],
                          ));
                    }).toList(),
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Pagination<Order>(
                data: (searchResult.isEmpty && !isSearching)
                    ? data!
                    : searchResult,
                onChange: (List<dynamic> data) {
                  _displayedDataStream.sink.add(data as List<Order>);
                },
                numPerPage: 20,
              ),
            )
          ],
        ),
      ),
    )));
  }

  @override
  void dispose() {
    _displayedDataStream.close();
    super.dispose();
  }
}
