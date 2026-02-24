import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/plc_store.dart';
import '../widgets/relay_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlcStore _store = PlcStore();

  Future<void> _toggleRelay(int index) async {
    try {
      await _store.toggleRelay(index);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showSettingsDialog() {
    final controller = TextEditingController(text: _store.plcAddress);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PLC Settings'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'PLC IP Address',
              hintText: '192.168.1.100:502',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Address is required';
              final parts = value.split(':');
              if (parts.length != 2)
                return 'Format: IP:PORT (e.g. 192.168.0.103:502)';
              final ipParts = parts[0].split('.');
              if (ipParts.length != 4 ||
                  ipParts.any(
                    (p) =>
                        int.tryParse(p) == null ||
                        int.parse(p) > 255 ||
                        int.parse(p) < 0,
                  )) {
                return 'Invalid IP address';
              }
              final port = int.tryParse(parts[1]);
              if (port == null || port < 1 || port > 65535)
                return 'Invalid port (1-65535)';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _store.updatePlcAddress(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) =>
              Text('PLC Controller (${_store.activeRelayCount}/4 ON)'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _store.refreshStates,
            tooltip: 'Refresh states',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status bar - wrapped in Observer
          Observer(
            builder: (_) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _store.isConnected
                    ? Colors.green.shade900.withOpacity(0.3)
                    : Colors.orange.shade900.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: _store.isConnected ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _store.isConnected ? Icons.check_circle : Icons.warning,
                    color: _store.isConnected
                        ? Colors.green.shade400
                        : Colors.orange.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _store.statusMessage,
                      style: TextStyle(
                        color: _store.isConnected
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Relay grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  // Each relay card wrapped in Observer
                  return Observer(
                    builder: (_) => RelayCard(
                      relayNumber: index + 1,
                      isOn: _store.relayStates[index],
                      isLoading: _store.relayLoading[index],
                      onToggle: () => _toggleRelay(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'allOff',
            onPressed: () async {
              for (int i = 0; i < 4; i++) {
                if (_store.relayStates[i]) {
                  await _store.toggleRelay(i);
                }
              }
            },
            backgroundColor: Colors.red.shade700,
            icon: const Icon(Icons.power_off),
            label: const Text('ALL OFF'),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'allOn',
            onPressed: () async {
              for (int i = 0; i < 4; i++) {
                if (!_store.relayStates[i]) {
                  await _store.toggleRelay(i);
                }
              }
            },
            backgroundColor: Colors.green.shade700,
            icon: const Icon(Icons.power),
            label: const Text('ALL ON'),
          ),
        ],
      ),
    );
  }
}
