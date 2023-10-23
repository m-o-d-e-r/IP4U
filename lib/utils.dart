
int convertIpToInteger(String ipAddress) {
  List<String> parts = ipAddress.split('.');
  int result = 0;

  for (int i = 0; i < 4; i++) {
    result += int.parse(parts[i]) << ((3 - i) * 8);
  }

  return result;
}


String convertIntegerToIp(int ipNumber) {
  List<int> parts = List.generate(4, (i) => (ipNumber >> (8 * (3 - i))) & 255);
  return parts.join('.');
}


int convertPrefixToInteger(int prefix) {
  List<String> bits = List.empty(growable: true);

  for (int i = 0; i < prefix; i++) {
    bits.add("1");
  }
  for (int i = 0; i < 32 - prefix; i++) {
    bits.add("0");
  }
  return int.parse(bits.join(""), radix: 2);
}


int invertNumber(int ip) {
  int bitCount = ip.bitLength;

  for (int i = 0; i < bitCount; i++) {
    ip = (ip ^ (1 << i));
  }

  return ip;
}
