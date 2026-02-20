import 'package:mobx/mobx.dart';
import '../services/plc_service.dart';

part 'plc_store.g.dart';

class PlcStore =  PlcStoreBase with _$PlcStore;

abstract class PlcStoreBase with Store {
  PlcStoreBase() {
    _plcService = PlcService(ip: plcAddress);
    statusMessage = _plcService.greet('PLC');
  }

  late PlcService _plcService;

  @observable
  String plcAddress = '192.168.0.105:502';

  @observable
  ObservableList<bool> relayStates = ObservableList.of([false, false, false, false]);

  @observable
  ObservableList<bool> relayLoading = ObservableList.of([false, false, false, false]);

  @observable
  bool isConnected = false;

  @observable
  String statusMessage = 'Not connected';

  @computed
  int get activeRelayCount => relayStates.where((state) => state).length;

  @action
  void updatePlcAddress(String newAddress) {
    plcAddress = newAddress;
    _plcService = PlcService(ip: plcAddress);
    statusMessage = 'IP updated to $plcAddress';
  }

  @action
  Future<void> toggleRelay(int index) async{
    relayLoading[index] = true;

    try {
      final newValue = !relayStates[index];
      await _plcService.setRelay(index, newValue);
      // Read actual states from PLC (interlock may override our command)
      final states = await _plcService.readRelays(0, 4);
      for (int i = 0; i < states.length; i++) {
        relayStates[i] = states[i];
      }
      isConnected = true;
      statusMessage = 'Connected to $plcAddress';
    } catch (e) {
      isConnected = false;
      statusMessage = 'Error: $e';
      rethrow;
    } finally {
      relayLoading[index] = false;
    }
  }

  @action
  Future<void> refreshStates() async {
    try {
      final states = await _plcService.readRelays(0, 4);
      for (int i = 0; i < states.length; i++) {
        relayStates[i] = states[i];
      }
      isConnected = true;
      statusMessage = 'Connected to $plcAddress';
    } catch (e) {
      isConnected = false;
      statusMessage = 'Error: $e';
    }
  }

}