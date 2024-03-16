class MyUser {
  String name;
  String uid;
  int financeBarValue;
  int academicBarValue;
  int careerBarValue;
  List<String> badges;
  String email;
  String? password;
  String? photoURL;

  MyUser({
    required this.name,
    required this.uid,
    required this.financeBarValue,
    required this.academicBarValue,
    required this.careerBarValue,
    required this.badges,
    required this.email,
    required this.password,
    this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'financeBarValue': financeBarValue,
      'academicBarValue': academicBarValue,
      'careerBarValue': careerBarValue,
      'badges': badges,
      'email': email,
      'photoURL': photoURL,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      name: map['name'],
      uid: map['uid'],
      financeBarValue: map['financeBarValue'],
      academicBarValue: map['academicBarValue'],
      careerBarValue: map['careerBarValue'],
      badges: List<String>.from(map['badges']),
      email: map['email'],
      password: map['password'],
      photoURL: map['photoURL'],
    );
  }
}