import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'carousel.dart';
import 'details_sheet.dart';
import 'mapPage.dart';

void main() {
  runApp(const CarouselApp());
}

class CarouselApp extends StatefulWidget {
  const CarouselApp({Key? key}) : super(key: key);

  @override
  State<CarouselApp> createState() => _CarouselAppState();
}

class _CarouselAppState extends State<CarouselApp> with TickerProviderStateMixin {
  late LatLng myPoint;
  bool isLoading = false;
  final defaultPoint = const LatLng(10.7292121, 122.546609);
  List<LatLng> points = [];
  List<Marker> markers = [];
  final MapController mapController = MapController();
  int? selectedIndex;
  bool showDetails = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> imagePaths = [
    'assets/images/picture1.png',
    'assets/images/picture2.png',
    'assets/images/picture3.png',
    'assets/images/picture4.png',
    'assets/images/picture5.png',
  ];

  @override
  void initState() {
    super.initState();
    myPoint = defaultPoint;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getCoordinates(LatLng startPoint, LatLng endPoint) async {
    setState(() => isLoading = true);

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248b326996f58d84a76940a8b0367c8aee3',
    );

    final List<ORSCoordinate> routeCoordinates =
    await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: startPoint.latitude, longitude: startPoint.longitude),
      endCoordinate: ORSCoordinate(
          latitude: endPoint.latitude, longitude: endPoint.longitude),
    );

    final List<LatLng> routePoints = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();

    setState(() {
      points = routePoints;
      isLoading = false;
    });
  }

  void handleTap(LatLng latLng) {
    setState(() {
      if (markers.length < 2) {
        markers.add(
          Marker(
            point: latLng,
            width: 80,
            height: 80,
            child: Draggable(
              feedback: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.location_on),
                color: Colors.black,
                iconSize: 45,
              ),
              onDragEnd: (details) {
                print("Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
              },
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.location_on),
                color: Colors.black,
                iconSize: 45,
              ),
            ),
          ),
        );
      }

      if (markers.length == 1) {
        const double zoomLevel = 16.5;
        mapController.move(latLng, zoomLevel);
      }

      if (markers.length == 2) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() => isLoading = true);
        });
        getCoordinates(markers[0].point, markers[1].point);
        LatLngBounds bounds =
        LatLngBounds.fromPoints(markers.map((m) => m.point).toList());
        mapController.fitBounds(bounds);
      }
    });
  }

  void openDetails(int index) {
    setState(() {
      selectedIndex = index;
      showDetails = true;
    });
    _animationController.forward();
  }

  void closeDetails() {
    _animationController.reverse().then((_) {
      setState(() => showDetails = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Buttons',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Carousel Buttons"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: showDetails ? closeDetails : null,
          child: Stack(
            children: [
              // Main content column
              Column(
                children: [
                  Expanded(
                    child: MapPage(
                      mapController: mapController,
                      myPoint: myPoint,
                      markers: markers,
                      points: points,
                      isLoading: isLoading,
                      onTap: handleTap,
                    ),
                  ),
                  // Carousel positioned naturally at bottom
                  Carousel(
                    imagePaths: imagePaths,
                    onItemSelected: openDetails,
                  ),
                ],
              ),
              // Animated details sheet
              if (showDetails && selectedIndex != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizeTransition(
                    sizeFactor: _animation,
                    child: DetailsSheet(
                      selectedIndex: selectedIndex!,
                      imagePaths: imagePaths,
                      onClose: closeDetails,
                    ),
                  ),
                ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}