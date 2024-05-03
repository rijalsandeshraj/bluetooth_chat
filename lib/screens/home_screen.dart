// ignore_for_file: use_build_context_synchronously

import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:bluetooth_chat/utils/show_custom_snack_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bondedDevices = ValueNotifier(<BluetoothDevice>[]);
  bool isListening = false;

  Future<bool> requestBluetoothPermissions() async {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    final int androidApiLevel = androidInfo.version.sdkInt;

    // Request permissions based on API level
    if (androidApiLevel >= 31) {
      // Android 12 and above
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();

      if (statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
          statuses[Permission.bluetoothConnect] == PermissionStatus.granted &&
          statuses[Permission.bluetoothAdvertise] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      // Below Android 12
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.location,
      ].request();
      if (statuses[Permission.bluetooth] == PermissionStatus.granted &&
          statuses[Permission.location] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions().then((value) {
      if (value) {
        showCustomSnackBar(context, 'Bluetooth permission granted');
      } else {
        showCustomSnackBar(context, 'Failed to get Bluetooth permission',
            taskSuccess: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: allBluetooth.streamBluetoothState,
        builder: (context, snapshot) {
          final bluetoothOn = snapshot.data ?? false;
          return Scaffold(
            appBar: AppBar(title: const Text("Bluetooth Chat")),
            floatingActionButton: switch (isListening) {
              true => null,
              false => FloatingActionButton(
                  onPressed: switch (bluetoothOn) {
                    false => null,
                    true => () {
                        allBluetooth.startBluetoothServer();
                        setState(() => isListening = true);
                      },
                  },
                  backgroundColor: bluetoothOn
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  child: const Icon(Icons.wifi_tethering),
                ),
            },
            body: isListening
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Listening for connections"),
                          const CircularProgressIndicator(),
                          FloatingActionButton(
                            child: const Icon(Icons.stop),
                            onPressed: () {
                              allBluetooth.closeConnection();
                              setState(() {
                                isListening = false;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BLUETOOTH: ${switch (bluetoothOn) {
                                true => "ON",
                                false => "OFF",
                              }}',
                              style: TextStyle(
                                  color:
                                      bluetoothOn ? Colors.green : Colors.red),
                            ),
                            ElevatedButton(
                              onPressed: switch (bluetoothOn) {
                                false => null,
                                true => () async {
                                    final devices =
                                        await allBluetooth.getBondedDevices();
                                    bondedDevices.value = devices;
                                  },
                              },
                              child: const Text("Bonded Devices"),
                            ),
                          ],
                        ),
                        if (!bluetoothOn)
                          const Center(
                            child: Text("Turn bluetooth on"),
                          ),
                        ValueListenableBuilder(
                            valueListenable: bondedDevices,
                            builder: (context, devices, child) {
                              return Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: bondedDevices.value.length,
                                  itemBuilder: (context, index) {
                                    final device = devices[index];
                                    return ListTile(
                                      title: Text(device.name),
                                      subtitle: Text(device.address),
                                      onTap: () {
                                        allBluetooth
                                            .connectToDevice(device.address);
                                      },
                                    );
                                  },
                                ),
                              );
                            })
                      ],
                    ),
                  ),
          );
        });
  }
}
