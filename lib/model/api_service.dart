// import 'dart:convert';
//
// UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));
//
// String userLoginToJson(UserLogin data) => json.encode(data.toJson());
//
// class UserLogin {
//   UserLogin({
//     this.email,
//     this.password,
//   });
//
//   String email;
//   String password;
//
//   factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
//     email: json["email"],
//     password: json["password"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "email": email,
//     "password": password,
//   };
// }