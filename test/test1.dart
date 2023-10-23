import 'package:ip4u/utils.dart';


void main() {
  print(convertIpToInteger("127.0.0.1"));
  print(convertIntegerToIp(2130706433));
  print(convertPrefixToInteger(25));
  print(convertIntegerToIp(convertPrefixToInteger(30)));
}
