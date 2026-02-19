// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plc_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlcStore on PlcStoreBase, Store {
  Computed<int>? _$activeRelayCountComputed;

  @override
  int get activeRelayCount => (_$activeRelayCountComputed ??= Computed<int>(
    () => super.activeRelayCount,
    name: 'PlcStoreBase.activeRelayCount',
  )).value;

  late final _$plcAddressAtom = Atom(
    name: 'PlcStoreBase.plcAddress',
    context: context,
  );

  @override
  String get plcAddress {
    _$plcAddressAtom.reportRead();
    return super.plcAddress;
  }

  @override
  set plcAddress(String value) {
    _$plcAddressAtom.reportWrite(value, super.plcAddress, () {
      super.plcAddress = value;
    });
  }

  late final _$relayStatesAtom = Atom(
    name: 'PlcStoreBase.relayStates',
    context: context,
  );

  @override
  ObservableList<bool> get relayStates {
    _$relayStatesAtom.reportRead();
    return super.relayStates;
  }

  @override
  set relayStates(ObservableList<bool> value) {
    _$relayStatesAtom.reportWrite(value, super.relayStates, () {
      super.relayStates = value;
    });
  }

  late final _$relayLoadingAtom = Atom(
    name: 'PlcStoreBase.relayLoading',
    context: context,
  );

  @override
  ObservableList<bool> get relayLoading {
    _$relayLoadingAtom.reportRead();
    return super.relayLoading;
  }

  @override
  set relayLoading(ObservableList<bool> value) {
    _$relayLoadingAtom.reportWrite(value, super.relayLoading, () {
      super.relayLoading = value;
    });
  }

  late final _$isConnectedAtom = Atom(
    name: 'PlcStoreBase.isConnected',
    context: context,
  );

  @override
  bool get isConnected {
    _$isConnectedAtom.reportRead();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.reportWrite(value, super.isConnected, () {
      super.isConnected = value;
    });
  }

  late final _$statusMessageAtom = Atom(
    name: 'PlcStoreBase.statusMessage',
    context: context,
  );

  @override
  String get statusMessage {
    _$statusMessageAtom.reportRead();
    return super.statusMessage;
  }

  @override
  set statusMessage(String value) {
    _$statusMessageAtom.reportWrite(value, super.statusMessage, () {
      super.statusMessage = value;
    });
  }

  late final _$toggleRelayAsyncAction = AsyncAction(
    'PlcStoreBase.toggleRelay',
    context: context,
  );

  @override
  Future<void> toggleRelay(int index) {
    return _$toggleRelayAsyncAction.run(() => super.toggleRelay(index));
  }

  late final _$refreshStatesAsyncAction = AsyncAction(
    'PlcStoreBase.refreshStates',
    context: context,
  );

  @override
  Future<void> refreshStates() {
    return _$refreshStatesAsyncAction.run(() => super.refreshStates());
  }

  late final _$PlcStoreBaseActionController = ActionController(
    name: 'PlcStoreBase',
    context: context,
  );

  @override
  void updatePlcAddress(String newAddress) {
    final _$actionInfo = _$PlcStoreBaseActionController.startAction(
      name: 'PlcStoreBase.updatePlcAddress',
    );
    try {
      return super.updatePlcAddress(newAddress);
    } finally {
      _$PlcStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
plcAddress: ${plcAddress},
relayStates: ${relayStates},
relayLoading: ${relayLoading},
isConnected: ${isConnected},
statusMessage: ${statusMessage},
activeRelayCount: ${activeRelayCount}
    ''';
  }
}
