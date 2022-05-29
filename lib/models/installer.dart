class Installer {
  final int id;
  final String name;
  final int rating;
  final int pricePerKm;
  final double lat;
  final double lng;

  factory Installer.fromJson(Map<String, dynamic> json) {
    return Installer(
      json['id'],
      json['name'],
      json['rating'],
      json['price_per_km'],
      json['lat'],
      json['lng'],
    );
  }

  Installer(
      this.id, this.name, this.rating, this.pricePerKm, this.lat, this.lng);
}
