class InternetPlan {
  final int id;
  final String isp;
  final double downloadSpeed;
  final double uploadSpeed;
  final String description;
  final double pricePerMonth;
  final String typeOfInternet;

  factory InternetPlan.fromJson(Map<String, dynamic> json) {
    return InternetPlan(
      json['id'],
      json['isp'],
      json['download_speed'],
      json['upload_speed'],
      json['description'],
      json['price_per_month'],
      json['type_of_internet'],
    );
  }

  InternetPlan(this.id, this.isp, this.downloadSpeed, this.uploadSpeed,
      this.description, this.pricePerMonth, this.typeOfInternet);
}
