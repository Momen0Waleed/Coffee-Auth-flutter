import 'package:coffee/core/constants/routes/page_routes_name.dart';
import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:coffee/core/constants/utils/firebase_authentication_utils.dart';
import 'package:coffee/modules/authentication/widgets/register_button_widget.dart';
import 'package:coffee/modules/authentication/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.gold
              , size: 30),
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
              // Image.asset(
              //   ImagesName.splashLogo,
              //   width: dynamicSize.width * 0.4,
              // ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 15,
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
                    RegisterButtonWidget(
                      bgColor: AppColors.gold
                      ,
                      child: Text(
                        "Create Account",
                        style: textTheme.titleMedium!.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      buttonAction: () {
                        setState(() async {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            FirebaseAuthenticationUtils.createUserWithEmailAndPassword(
                              emailAddress: mailController.text,
                              password: passwordController.text,
                            ).then((value) async {
                              await FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(nameController.text);
                              await FirebaseAuth.instance.currentUser!.reload();
                              if (value) {
                                EasyLoading.dismiss();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            });
                          }
                        });
                      },
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
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(PageRoutesName.login);
                          },
                          child: Text(
                            "Login",
                            style: textTheme.bodyLarge!.copyWith(
                              color: AppColors.gold
                              ,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gold
                              ,
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
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
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
