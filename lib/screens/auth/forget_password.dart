import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Forget password"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter your Email We will send you a link to change password",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: controller,
                hintText: "enter your email number",
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E77CF),
                        shadowColor: Colors.grey.withOpacity(0.5)),
                    onPressed: () {
                      controller.text.isEmpty
                          ? EasyLoading.showError(
                              "please enter your email first")
                          : auth.forgetPassword(controller.text);
                          
                    },
                    child: Text("Confirm",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
