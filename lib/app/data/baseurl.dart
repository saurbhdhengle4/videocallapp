class BaseUrl {
  static const String dev = "https://reqres.in/";
  static const String staging = "https://reqres.in/";
  static const String production = "https://reqres.in/";
  static const String current = production;
  static bool get isProd => current == production;
  static bool get isDev => current == dev;
  static bool get isStaging => current == staging;
  static const String googleMapKey = "";
}
