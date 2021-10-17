import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:atoz/helpers/validators.dart';
import 'package:flutter/material.dart';

import '../api.dart';

class Register extends StatelessWidget {
  final Api api;

  const Register({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    InputText(
                      placeholder: "Name",
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                      placeholder: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                        placeholder: "Password",
                        obscureText: true,
                        controller: passwordController,
                        validator: Validators.passwordValidator),
                    const SizedBox(
                      height: 10,
                    ),
                    InputText(
                        placeholder: "Repeat password",
                        obscureText: true,
                        validator: (val) {
                          if (val != passwordController.value.text) {
                            return "Password does not match!";
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    InputButton(
                      value: "Register",
                      onTap: () {
                        if (formKey.currentState != null &&
                            formKey.currentState!.validate()) {
                          api.userController.register(
                              nameController.value.text,
                              emailController.value.text,
                              passwordController.value.text,
                              context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text("Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
