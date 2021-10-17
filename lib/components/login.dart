import 'package:atoz/components/register.dart';
import 'package:atoz/components/reuseable/input_button.dart';
import 'package:atoz/components/reuseable/input_text.dart';
import 'package:atoz/helpers/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api.dart';

class Login extends StatelessWidget {
  final Api api;

  const Login({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                InputText(
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: Validators.emailValidator,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputText(
                    placeholder: "Password",
                    controller: passwordController,
                    obscureText: true,
                    validator: Validators.passwordValidator),
                const SizedBox(
                  height: 20,
                ),
                InputButton(
                  value: "Login",
                  onTap: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      api.userController.login(emailController.value.text,
                          passwordController.value.text);
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => Register(api: api)));
                    },
                    child: const Text("Register",
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
          )),
    );
  }
}
