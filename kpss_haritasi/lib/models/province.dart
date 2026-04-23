import 'dart:ui';

class Province {
  final String id; // plaka kodu
  final String name;
  final Path path;
  final Offset center;

  Province({
    required this.id,
    required this.name,
    required this.path,
    required this.center,
  });

  bool contains(Offset point) => path.contains(point);
}
