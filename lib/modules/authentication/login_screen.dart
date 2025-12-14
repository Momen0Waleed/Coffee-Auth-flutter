import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/core/constants/images/images_dir.dart';
import 'package:coffee/core/constants/routes/page_routes_name.dart';
import 'package:coffee/core/constants/services/snackbar_service.dart';
import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:coffee/core/constants/utils/firebase_authentication_utils.dart';
import 'package:coffee/modules/authentication/widgets/register_button_widget.dart';
import 'package:coffee/modules/authentication/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
    double errorHeight = 25;

  @override
  Widget build(BuildContext context) {
    var dynamicSize = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImagesDir.logo, width: dynamicSize.width * 0.4),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFieldWidget(
                            color: AppColors.white,
                            textColor: AppColors.gray,
                            borderColor: AppColors.gray,
                            title: "Email",
                            prefixIcon: Icon(
                              Icons.mail_rounded,
                              color: AppColors.gray,
                            ),
                            controller: mailController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter your email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: errorHeight),
                          TextFieldWidget(
                            color: AppColors.white,
                            textColor: AppColors.gray,
                            borderColor: AppColors.gray,
                            title: "Password",
                            prefixIcon: Icon(
                              Icons.lock_rounded,
                              color: AppColors.gray,
                            ),
                            isPassword: true,
                            controller: passwordController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter your password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Bounceable(
                              onTap: () {},
                              child: Text(
                                "Forget Password ?",
                                style: theme.bodyLarge!.copyWith(
                                  color: AppColors.gold,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 1.5,
                                  decorationColor: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: dynamicSize.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RegisterButtonWidget(
                            bgColor: AppColors.gold,
                            child: Text(
                              "Login",
                              style: theme.titleMedium!.copyWith(
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            buttonAction: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() { errorHeight = 25; });
                                EasyLoading.show();

                                FirebaseAuthenticationUtils.signInWithEmailAndPassword(
                                  emailAddress: mailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ).then((success) async {
                                  EasyLoading.dismiss();

                                  if (!success) return; // Stop if login failed

                                  final user = FirebaseAuth.instance.currentUser;
                                  if (user == null) {
                                    SnackbarService.showErrorNotification("Could not retrieve user details.");
                                    return;
                                  }
                                  final String uid = user.uid;

                                  if (!context.mounted) return;

                                  // 2. Build the deep link URI using the UID.
                                  final Uri androidAppUrl = Uri.parse("coffeeandroid://home?uid=$uid");

                                  if (await canLaunchUrl(androidAppUrl)) {
                                    await launchUrl(androidAppUrl, mode: LaunchMode.externalApplication);
                                  } else {
                                    SnackbarService.showErrorNotification("Could not launch Android App");
                                  }

                                });
                              } else {
                                setState(() { errorHeight = 10; });
                              }
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  height: 3,
                                  color: AppColors.gold,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                " OR ",
                                style: theme.bodyLarge!.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  height: 3,
                                  color: AppColors.gold,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Don't Have an Account? ",
                                style: theme.bodyLarge!.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              Bounceable(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(PageRoutesName.register);
                                },
                                child: Text(
                                  "Create Account",
                                  style: theme.bodyLarge!.copyWith(
                                    color: AppColors.gold,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 1.5,
                                    decorationColor: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
