import '../src/rust/api/simple.dart' as rust;

class PlcService {
  final String ip;

  PlcService({required this.ip});

  // turn a relay on or off
  Future<void> setCoil(int address, bool value) async {
    await rust.setCoil(ip: ip, address: address, value: value);
  }

  // read states of multiple relays
  Future<List<bool>> readCoils(int start, int count) async {
    return await rust.readCoils(ip: ip, start: start, count: count);
  }

  // test the connection
  String greet(String name) {
    return rust.greet(name: name);
  }
}