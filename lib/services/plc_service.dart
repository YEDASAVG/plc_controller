import '../src/rust/api/simple.dart' as rust;

class PlcService {
  final String ip;

  PlcService({required this.ip});

  // turn a relay on or off
  Future<void> setRelay(int index, bool value) async {
    await rust.setRelay(ip: ip, index: index, value: value);
  }

  // read states of multiple relays
  Future<List<bool>> readRelays(int start, int count) async {
    return await rust.readRelays(ip: ip, count: count);
  }

  // test the connection
  String greet(String name) {
    return rust.greet(name: name);
  }
}
