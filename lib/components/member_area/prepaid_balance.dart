import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:flutter/material.dart';

import '../../api.dart';
import 'member_identity.dart';

class PrepaidBalance extends StatefulWidget {
  final Api api;

  const PrepaidBalance({Key? key, required this.api}) : super(key: key);

  @override
  State<PrepaidBalance> createState() => _PrepaidBalanceState();
}

class _PrepaidBalanceState extends State<PrepaidBalance> {
  int price = 10000;
  late TextEditingController mobileNumberController;

  @override
  void initState() {
    mobileNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberIdentity(api: widget.api),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prepaid Balance",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    InputText(
                        placeholder: "Mobile number",
                        keyboardType: TextInputType.number,
                        controller: mobileNumberController,
                        validator: (val) {
                          final regex = RegExp(r'081(\d+)');

                          if (!regex.hasMatch(val!) ||
                              val.length < 7 ||
                              val.length > 10) {
                            return "Enter a valid mobile number!";
                          }
                        }),
                    const SizedBox(height: 10),
                    DropdownButton(
                        value: price,
                        onChanged: (int? val) {
                          setState(() {
                            price = val!;
                          });
                        },
                        items: [10000, 50000, 100000]
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.toString())))
                            .toList()),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: InputButton(
                          value: "Submit",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              widget.api.orderController.orderBalance(
                                  mobileNumberController.value.text,
                                  price.toString());
                            }
                          },
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )));
  }
}
