class Customer {
  int? id;
  String name;
  String lastname;
  String email;
  String phonenumber;

  Customer({
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phonenumber,
  });

  @override
  String toString() {
    return '$name $lastname ($phonenumber)';
  }
}
