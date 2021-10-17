import 'package:atoz/api.dart';
import 'package:atoz/components/member_area/order_history.dart';
import 'package:atoz/components/member_area/prepaid_balance.dart';
import 'package:atoz/models/initial_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'buy_product.dart';

class MemberIdentity extends StatelessWidget {
  final Api api;

  const MemberIdentity({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light));

    return StreamBuilder(
      stream: api.publicInitialDataState.getStream(),
      initialData: api.temporaryInitialData,
      builder: (context, AsyncSnapshot<InitialData> snapshot) {
        final initialData = snapshot.data!;
        final name = initialData.name ?? initialData.email;

        return Container(
          decoration: const BoxDecoration(color: Colors.blue),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $name!",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: initialData.unpaidOrders.toString(),
                            style: const TextStyle(color: Colors.red)),
                        const TextSpan(
                            text: " unpaid order",
                            style: TextStyle(color: Color(0xFF888888))),
                      ])),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => OrderHistory(api: api)));
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("Order history")),
                    ),
                  ],
                ),
              ),
              Flexible(
                  child: Row(children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => PrepaidBalance(api: api)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          Icon(Icons.account_balance_wallet),
                          SizedBox(height: 8),
                          Text("Prepaid Balance",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => BuyProduct(api: api)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          Icon(Icons.shopping_cart),
                          SizedBox(height: 8),
                          Text("Product Page",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                )
              ]))
            ],
          ),
        );
      },
    );
  }
}
