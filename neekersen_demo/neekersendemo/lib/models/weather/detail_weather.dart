class DetailWeather {
  final String date;
  final String day;
  final String icon;
  final String description;
  final String status;
  final String degree;
  final String min;
  final String max;
  final String night;
  final String humidity;

  DetailWeather(
      {required this.date,
      required this.day,
      required this.icon,
      required this.description,
      required this.status,
      required this.degree,
      required this.min,
      required this.max,
      required this.night,
      required this.humidity});
}
