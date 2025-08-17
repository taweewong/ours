import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ours/presentation/resource/themes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.theme.primaryColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginTextField(
                  hintText: context.tr('app.loginUsernameHint'),
                  onTextChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                LoginTextField(
                  hintText: context.tr('app.loginPasswordHint'),
                  onTextChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: MaterialButton(
                    color: Colors.amber,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('$username $password'),
                      ));
                    },
                    child: Text(
                      context.tr('app.loginButton'),
                      style: context.theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onTextChanged;

  LoginTextField({required this.hintText, required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.theme.textTheme.bodyLarge?.copyWith(
        color: context.theme.customColors.secondaryColor,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: context.theme.customColors.secondaryColor, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: context.theme.customColors.accentColor, width: 3.0),
        ),
        hintText: hintText,
      ),
      onChanged: onTextChanged,
    );
  }
}

