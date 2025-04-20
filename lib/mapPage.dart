import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class MapPage extends StatelessWidget {
  final MapController mapController;
  final LatLng myPoint;
  final List<Marker> markers;
  final List<LatLng> points;
  final bool isLoading;
  final Function(LatLng) onTap;

  const MapPage({
    Key? key,
    required this.mapController,
    required this.myPoint,
    required this.markers,
    required this.points,
    required this.isLoading,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            zoom: 16,
            center: myPoint,
            onTap: (tapPosition, latLng) => onTap(latLng),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            MarkerLayer(markers: markers),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  color: Colors.pinkAccent,
                  strokeWidth: 5,
                ),
              ],
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}