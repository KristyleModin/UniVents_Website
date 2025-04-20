import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  bool _isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: 800,
            width: 500,
            child: Column(
              children: [
                Image.asset(
                  "lib/images/univents_logo.png",
                  width: 200,
                  height: 150,
                ),
                Text(
                  "UniVents",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "abc@email.com",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE4DFDF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE4DFDF),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                TextField(
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    hintText: "Your password",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE4DFDF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE4DFDF),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: _isSwitchOn,
                          onChanged: (bool value) {
                            setState(() {
                              _isSwitchOn = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Color(0xFF182C8C),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Color(0xFF979797),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF120D26),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 280,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF182C8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Color(0xFF3D56F0),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'OR',
                  style: TextStyle(
                    color: Color(0xff9D9898),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: 55,
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/google_logo.png',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1C1B1F), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: 55,
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/facebook_logo.png',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Login with Facebook",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1C1B1F), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF182C8C),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
