import 'package:flutter/material.dart';

class DetailsSheet extends StatelessWidget {
  final int selectedIndex;
  final List<String> imagePaths;
  final VoidCallback onClose;

  const DetailsSheet({
    Key? key,
    required this.selectedIndex,
    required this.imagePaths,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 20, right: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Details for Image ${selectedIndex + 1}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Here's some descriptive text that could go here for this image. You can customize this further.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(imagePaths[selectedIndex]),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}