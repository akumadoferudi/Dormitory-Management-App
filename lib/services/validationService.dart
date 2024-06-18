

class ValidationService {

  bool isEmail(String email){
    final regex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }
  
  bool isPhoneNumber(String number){
    final regex = RegExp(r"^0[0-9]{9,11}$");
    return regex.hasMatch(number);
  }

}