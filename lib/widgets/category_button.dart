import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    Key key,
    @required this.isCollap,
    @required this.buttonLabel,
    @required this.buttonIcon,
    @required this.selectCategory,
    @required this.selectedCate,
    @required this.catIndex,
  }) : super(key: key);

  final String selectedCate;
  final Function selectCategory;
  final Icon buttonIcon;
  final String buttonLabel;
  final bool isCollap;
  final int catIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectCategory(buttonLabel),
      child: AnimatedContainer(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 14, bottom: 10),
        padding: EdgeInsets.all(10),
        child: Center(
          child: isCollap
              ? Container(
                  child: Text(
                    '${catIndex+1}',
                    
                    style: TextStyle(

                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // shadows: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     spreadRadius: 6,
                      //     blurRadius: 3,
                      //     offset: Offset(0, 2), // changes position of shadow
                      //   ),
                      // ],
                    ),
                  ),
                )
              : AutoSizeText(
                  buttonLabel.toUpperCase(),
                  textAlign: TextAlign.center,
                  minFontSize: 10,
                  maxFontSize: 60,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          border: selectedCate == buttonLabel
              ? Border.all(
                  color: Colors.blueAccent,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        height: 80,
        width: isCollap ? 80 : 180,
      ),
    );
  }
}
