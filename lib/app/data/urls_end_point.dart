class APIEndPoints {
  static const String login = "api/login/";
  static String userList({required int page}) =>
      "api/users?page=$page&per_page=10";
}
