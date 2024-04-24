class UserModel{
  String? name;
  String? email,userId,userPhone,address, selectedAge, selectedGender;
  UserModel({
    this.name,
    this.email,this.address,this.userId,this.userPhone, this.selectedAge, this.selectedGender
});
  Map<String, dynamic> asMap() {

    return {
      'name': name??'',
      'email': email??'',
      'address': address??'',
      'userId': userId??'',
      'userPhone': userPhone??'',
      'selectedAge': selectedAge??'',
      'selectedGender': selectedGender??''
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'],
        userId: map['userId'],
        email: map['email'],
        userPhone: map['userPhone'],
        address: map['address'],
        selectedAge: map['selectedAge'],
        selectedGender: map['selectedGender']
    );
  }
}