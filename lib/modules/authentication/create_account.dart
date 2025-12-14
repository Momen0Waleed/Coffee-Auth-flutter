import 'dart:async';

import 'package:coffee/core/constants/images/images_dir.dart';
import 'package:coffee/core/constants/routes/page_routes_name.dart';
import 'package:coffee/core/constants/services/snackbar_service.dart';
import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:coffee/core/constants/utils/firebase_authentication_utils.dart';
import 'package:coffee/modules/authentication/widgets/register_button_widget.dart';
import 'package:coffee/modules/authentication/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
    double errorHeight = 25;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var dynamicSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.gold, size: 30),
        ),
        title: Text("Register"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImagesDir.logo, width: dynamicSize.width * 0.4),
              Form(
                key: _formKey,
                child: Column(
                  spacing: errorHeight,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                      color: AppColors.white,
                      title: "Name",
                      textColor: AppColors.gray,
                      borderColor: AppColors.gray,
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: AppColors.gray,
                      ),
                      validator: validateName,
                      controller: nameController,
                    ),
                    TextFieldWidget(
                      color: AppColors.white,
                      title: "Email",
                      textColor: AppColors.gray,
                      borderColor: AppColors.gray,
                      prefixIcon: Icon(
                        Icons.mail_rounded,
                        color: AppColors.gray,
                      ),
                      validator: validateEmail,
                      controller: mailController,
                    ),
                    TextFieldWidget(
                      color: AppColors.white,
                      title: "Password",
                      textColor: AppColors.gray,
                      borderColor: AppColors.gray,
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: AppColors.gray,
                      ),
                      isPassword: true,
                      validator: validatePassword,
                      controller: passwordController,
                    ),
                    TextFieldWidget(
                      color: AppColors.white,
                      title: "Confirm Password",
                      textColor: AppColors.gray,
                      borderColor: AppColors.gray,
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                        color: AppColors.gray,
                      ),
                      isPassword: true,
                      validator: validateConfirmPassword,
                      controller: confirmPasswordController,
                    ),
                    SizedBox(height: 10),
                    RegisterButtonWidget(
                      bgColor: AppColors.gold,
                      child: Text(
                        "Create Account",
                        style: textTheme.titleMedium!.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      buttonAction: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            errorHeight = 25;
                          });
                          EasyLoading.show();
                          FirebaseAuthenticationUtils.createUserWithEmailAndPassword(
                            emailAddress: mailController.text,
                            password: passwordController.text,
                          ).then((value) async {
                            EasyLoading.dismiss();

                            if (value == true) {
                              // try {
                              //   if (FirebaseAuth.instance.currentUser != null) {
                              //     await FirebaseAuth.instance.currentUser!
                              //         .updateDisplayName(nameController.text);
                              //     await FirebaseAuth.instance.currentUser!.reload();
                              //   }
                              //   if (context.mounted) {
                              //     SnackbarService.showSuccessNotification("Created");
                              //     Timer(Duration(seconds: 5), (){});
                              //     Navigator.pop(context);
                              //   }
                              // } catch (e) {
                              //   print("Profile update error: $e");
                              // }

                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {   // 1. Update the display name in Firebase (This is still good practice)
                                  await user.updateDisplayName(nameController.text);

                                  // 2. Reload the user profile to save the change
                                  await user.reload();

                                  // 3. Re-fetch the user object to be safe
                                  final freshUser = FirebaseAuth.instance.currentUser;
                                  if (freshUser == null) {
                                    SnackbarService.showErrorNotification("Could not verify user session.");
                                    return;
                                  }

                                  // 4. Get the UID from the fresh user object
                                  final String uid = freshUser.uid;

                                  // 5. Build the deep link URI using the UID
                                  final Uri androidAppUrl = Uri.parse("coffeeandroid://home?uid=$uid");

                                  if (context.mounted) {
                                    // 6. Launch the native Android App
                                    if (await canLaunchUrl(androidAppUrl)) {
                                      await launchUrl(androidAppUrl, mode: LaunchMode.externalApplication);

                                      // (Optional) You can still pop this screen after launching
                                      // Navigator.pop(context);
                                    } else {
                                      SnackbarService.showErrorNotification("Account created, but could not launch app.");
                                    }
                                  }
                                }
                              } catch (e) {
                                print("Profile update or launch error: $e");
                                if(context.mounted){
                                  SnackbarService.showErrorNotification("An error occurred updating your profile.");
                                }
                              }
                            }
                          });
                        } else {
                          setState(() {
                            errorHeight = 10;
                          });
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
                          style: textTheme.bodyLarge!.copyWith(
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
                          "Already Have an Account? ",
                          style: textTheme.bodyLarge!.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        Bounceable(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(PageRoutesName.login);
                          },
                          child: Text(
                            "Login",
                            style: textTheme.bodyLarge!.copyWith(
                              color: AppColors.gold,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gold,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationThickness: 1.5,
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
      ),
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is Required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is Required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Invalid Email Format";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is Required";
    }
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{6,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
      return "Password must contain uppercase, lowercase,\nnumber, and special character.";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm Password is Required";
    }
    if (value != passwordController.text) {
      return "Password and Confirm Password must be same";
    }
    return null;
  }
}
