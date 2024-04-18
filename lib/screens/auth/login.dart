import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_circuler/component/custom_textfield.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/screens/admin/admin_first_screen.dart';
import 'package:job_circuler/screens/auth/forget_password.dart';
import 'package:job_circuler/screens/auth/sign_up.dart';
import 'package:job_circuler/screens/home/dashboard_Screen.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final hight = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff1E77CF), // Change this color to your desired color
    ));
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FC),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: const Color(0xffF5F8FC),
                  height: hight,
                  width: width,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      ClipPath(
                        clipper: OvalBottomBorderClipper(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xff1E77CF),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 40, left: 25),
                                child: Text(
                                  "Sign in",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: hight * 0.2,
                        left: width * 0.06,
                        right: width * 0.06,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .65, // Adjust as needed
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes the position of the shadow
                                ),
                              ]),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: CustomTextField(
                                    controller: emailController,
                                    prefixIconUrl: Icons.mail_outline,
                                    isShowPrefixIcon: true,
                                    validation: (email) {
                                      if (RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email!)) {
                                        return null;
                                      } else {
                                        return 'Please enter a valid email';
                                      }
                                    },
                                    borderRadius: 30,
                                    fillColor: Colors.white,
                                    isShowBorder: true,
                                    verticalSize: 15,
                                    horizontalSize: 20,
                                    hintText: "Email",
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  child: CustomTextField(
                                    controller: passwordController,
                                    prefixIconUrl: Icons.lock_open_outlined,
                                    isShowPrefixIcon: true,
                                  
                                    validation: (password) {
                                      if (password!.isEmpty) {
                                        return "please enter your password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    borderRadius: 30,
                                    fillColor: Colors.white,
                                    isShowBorder: true,
                                    verticalSize: 15,
                                    
                                    horizontalSize: 20,
                                    hintText: "Password",
                                      isPassword: true,
                                      isShowSuffixIcon:true,
                                  )),
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
                                      if (_formKey.currentState!.validate()) {
                                        if (emailController.text == "gausbd.com.server" &&
                                            passwordController.text ==
                                                "see you again @bd&9900faysal") {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => AdminFirstScreen()));
                                        } else {
                                          provider
                                              .signIn(emailController.text, passwordController.text)
                                              .then((value) {
                                            if (value) {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                  builder: (context) => DashboardScreen()));
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Text("Sign in",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: (){
                                   Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => const ForgetPassword()));
                                },
                                child: Text("Forget password",
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                              ),
                              const Divider(),
                              Text("or continue with",
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.black, width: 0.3)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(children: [
                                      const Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: width * 0.13,
                                      ),
                                      const Text("Continue with Google")
                                    ]),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.black, width: 0.3)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(children: [
                                      const Icon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: width * 0.13,
                                      ),
                                      const Text("Continue with Facebook")
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25, top: hight * .87),
                        child: Text.rich(TextSpan(
                            text: 'New to here?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black, fontSize: 15),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const SignUpScreen()));
                                  },
                                text: ' Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 20, color: Colors.blue),
                              )
                            ])),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
