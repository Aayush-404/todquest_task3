class UserModel{
  final String userName;
  final String mail;
  final String password;
  final String source;

  UserModel({
    this.password = "",
    this.mail = "",
    this.source = "",
    this.userName = ""
  });

  Map<String, dynamic> toJson() =>{
    'userName': userName,
    'password': password,
    'mail': mail,
    'source': source
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    userName: json['userName'],
    password: json['password'],
    mail: json['mail'],
    source: json['source']
  );
}