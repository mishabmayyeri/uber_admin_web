import 'package:flutter/material.dart';

class CommonMethods {
  Widget header(int flexValue, String title) {
    return Expanded(
      flex: flexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.pink.shade500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget data(int flexValue, Widget widget) {
    return Expanded(
      flex: flexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          // color: Colors.pink.shade500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: widget,
        ),
      ),
    );
  }
}
