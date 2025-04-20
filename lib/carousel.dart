import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<String> imagePaths;
  final Function(int) onItemSelected;

  const Carousel({
    Key? key,
    required this.imagePaths,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  double _currentPage = 0.0;
  final Set<int> _hoveredItems = {};

  @override
  void initState() {
    super.initState();
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;

    _pageController = PageController(
      viewportFraction: screenWidth > 800 ? 0.25 : 0.4,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isFocusedOrHovered(int index) {
    final isCentered = (_currentPage - index).abs() < 0.1;
    final isHovered = _hoveredItems.contains(index);
    return isCentered || isHovered;
  }

  double _getScale(bool isFocused) => isFocused ? 1.8 : 0.7;

  BorderRadius _getBorderRadius(bool isFocused) =>
      isFocused ? BorderRadius.circular(20) : BorderRadius.circular(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          final isFocused = _isFocusedOrHovered(index);
          final scale = _getScale(isFocused);
          final borderRadius = _getBorderRadius(isFocused);
          const double baseSize = 60.0;

          return Center(
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredItems.add(index)),
              onExit: (_) => setState(() => _hoveredItems.remove(index)),
              child: GestureDetector(
                onTap: () => widget.onItemSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: baseSize * scale,
                  width: isFocused ? baseSize * scale * 2.0 : baseSize * scale,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.grey[300],
                    boxShadow: [
                      if (isFocused)
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(widget.imagePaths[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: isFocused
                      ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black54,
                      child: Text(
                        'Button ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}