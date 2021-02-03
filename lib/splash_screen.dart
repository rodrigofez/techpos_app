import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cargando',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                            height: 40,
                            // width: 200,
                            child: SvgPicture.asset(
                              'assets/images/logo.svg',
                            ),
                          ),
            
            SizedBox(height: 16,),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
