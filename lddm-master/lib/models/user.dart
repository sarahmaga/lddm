class User {

  late final String? id;
  late final String? name;
  late final String? email;
  late final String? username;
  late final String? password;

  late final bool? isCaretaker;
  late final bool? isSelfSufficient;

  late final String? caretakerId;
  User.basic(this.id);

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.isCaretaker,
    required this.isSelfSufficient,
    this.caretakerId
  });

}