import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ours/presentation/resource/themes.dart';

import '../../model/login/login_user.dart';
import 'login_state.dart';

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
    // ref.listen must be above the ref.watch
    ref.listen<AsyncValue<LoginUser?>>(loginStateNotifierProvider, (previous, next) {
      next.whenOrNull(
          data: (user) {
            if (user != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(user.uid)));
              });
            }
          },
          error: (err, _) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(err.toString())));
          }
      );
    });

    var loginState = ref.watch(loginStateNotifierProvider);

    return Scaffold(
      body: Container(
        color: context.theme.primaryColor,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginTextField(
                      hintText: context.tr('app.loginUsernameHint'),
                      isPassword: false,
                      onTextChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    LoginTextField(
                      hintText: context.tr('app.loginPasswordHint'),
                      isPassword: true,
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
                          _login();
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
            _buildLoading(loginState.isLoading),
          ],
        ),
      ),
    );
  }

  void _login() {
    ref
        .read(loginStateNotifierProvider.notifier)
        .login(email: username, password: password);
  }

  Widget _buildLoading(bool isLoading) {
    if (isLoading) {
      return Container(
          color: Color(0x7E000000),
          child: Center(child: CircularProgressIndicator())
      );
    }
    return const SizedBox.shrink();
  }
}

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final Function(String) onTextChanged;

  LoginTextField({
    required this.hintText, required this.onTextChanged, required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.theme.textTheme.bodyLarge?.copyWith(
        color: context.theme.customColors.secondaryColor,
      ),
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.customColors.secondaryColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.customColors.accentColor,
            width: 3.0,
          ),
        ),
        hintText: hintText,
      ),
      onChanged: onTextChanged,
    );
  }
}
