class Weather {
  String date;
  String day;
  String icon;
  String description;
  String status;
  String degree;
  String min;
  String max;
  String night;
  String humidity;

  Weather({
    required this.date,
    required this.day,
    required this.icon,
    required this.description,
    required this.status,
    required this.degree,
    required this.min,
    required this.max,
    required this.night,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      degree: json['degree'] ?? '',
      min: json['min'] ?? '',
      max: json['max'] ?? '',
      night: json['night'] ?? '',
      humidity: json['humidity'] ?? '',
    );
  }
  String getTextByLocale(String locale) {
    if (locale == 'tr') return description;
    return status;
  }

  String getDayByLocale(String locale) {
    const dayMap = {
      "Pazartesi": {"tr": "Pazartesi", "en": "Monday"},
      "Salı": {"tr": "Salı", "en": "Tuesday"},
      "Çarşamba": {"tr": "Çarşamba", "en": "Wednesday"},
      "Perşembe": {"tr": "Perşembe", "en": "Thursday"},
      "Cuma": {"tr": "Cuma", "en": "Friday"},
      "Cumartesi": {"tr": "Cumartesi", "en": "Saturday"},
      "Pazar": {"tr": "Pazar", "en": "Sunday"},
    };

    if (!dayMap.containsKey(day)) return day;
    return dayMap[day]![locale] ?? day;
  }
}
