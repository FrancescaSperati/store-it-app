class UserDTO {

  final String userName;
  final String userEmail;
  final String password;
  final String sessionKey;
  final String userId;


  UserDTO(this.userId, this.userName, this.userEmail, this.password, this.sessionKey);
}