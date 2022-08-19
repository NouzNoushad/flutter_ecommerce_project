import 'package:flutter/material.dart';
import 'database/db.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // controllers
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confrimPassword = TextEditingController();
  // password visibility
  bool isPasswordObscure = true;
  bool isCPasswordObscure = true;

  // database
  MyDb myDb = MyDb();
  @override
  void initState() {
    myDb.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.orange.shade800,
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                usernameTextFormField(),
                emailTextFormField(),
                passwordTextFormField(),
                confirmPasswordTextFormField(),
                elevatedButtonWidget(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an Account? ",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 15,
                          ),
                        ),
                      ],
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

  Widget confirmPasswordTextFormField() => TextFormField(
        controller: _confrimPassword,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "confirm password should not be empty";
          } else if (value.length > 8) {
            return "confirm password should not exceed 8 characters";
          }
          if (_password.text != _confrimPassword.text) {
            return "Password does not match";
          }
          return null;
        },
        obscureText: isCPasswordObscure,
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "confirm password",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.orange,
            size: 20,
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isCPasswordObscure = !isCPasswordObscure;
                });
              },
              child: isCPasswordObscure
                  ? const Icon(
                      Icons.visibility_off,
                      color: Colors.orange,
                      size: 20,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: Colors.orange,
                      size: 20,
                    )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget passwordTextFormField() => TextFormField(
        controller: _password,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "password should not be empty";
          } else if (value.length > 8) {
            return "password should not exceed 8 characters";
          }
          return null;
        },
        obscureText: isPasswordObscure,
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "password",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.orange,
            size: 20,
          ),
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscure = !isPasswordObscure;
                });
              },
              child: isPasswordObscure
                  ? const Icon(
                      Icons.visibility_off,
                      color: Colors.orange,
                      size: 20,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: Colors.orange,
                      size: 20,
                    )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget emailTextFormField() => TextFormField(
        controller: _email,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "email should not be empty";
          } else if (!value.contains('@')) {
            return "Please enter valid email address";
          }
          return null;
        },
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "email",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.orange,
            size: 20,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget usernameTextFormField() => TextFormField(
        controller: _username,
        validator: (String? value) {
          if (value!.isEmpty) {
            return "username should not be empty";
          }
          return null;
        },
        cursorColor: Colors.orange,
        style: const TextStyle(
          color: Colors.orange,
        ),
        decoration: InputDecoration(
          hintText: "username",
          hintStyle: const TextStyle(
            color: Colors.orange,
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.orange,
            size: 20,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.orange)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: Colors.red)),
        ),
      );

  Widget elevatedButtonWidget() => SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await myDb.db!.rawInsert(
                  "INSERT INTO users (username, email, password) VALUES (?, ?, ?);",
                  [
                    _username.text,
                    _email.text,
                    _password.text,
                  ]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(
                      "New user Registered",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    )),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
              _username.text = "";
              _email.text = "";
              _password.text = "";
              _confrimPassword.text = "";
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Sign up",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 15,
            ),
          ),
        ),
      );
}
