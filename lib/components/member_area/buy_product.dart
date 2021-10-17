import 'package:atoz/api.dart';
import 'package:atoz/components/member_area/member_identity.dart';
import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:flutter/material.dart';

class BuyProduct extends StatelessWidget {
  final Api api;

  const BuyProduct({Key? key, required this.api}) : super(key: key);

  String? textareaValidator(val) {
    if (val == null || val.length < 10) {
      return "Too short!";
    } else if (val.length > 150) {
      return "You have reached maximum characters!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final productNameController = TextEditingController();
    final shippingAddressController = TextEditingController();
    final priceController = TextEditingController();

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
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Page",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    InputText(
                        maxLines: 5,
                        placeholder: "Product name",
                        keyboardType: TextInputType.multiline,
                        controller: productNameController,
                        validator: textareaValidator),
                    const SizedBox(height: 10),
                    InputText(
                      maxLines: 5,
                      placeholder: "Shipping address",
                      keyboardType: TextInputType.multiline,
                      controller: shippingAddressController,
                      validator: textareaValidator,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                        placeholder: "Price",
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please input a valid number!";
                          }
                        }),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: InputButton(
                          value: "Submit",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              api.orderController.orderProduct(
                                  productNameController.value.text,
                                  shippingAddressController.value.text,
                                  priceController.value.text);
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
