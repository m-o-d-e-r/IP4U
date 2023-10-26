import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ip4u/utils.dart';
import 'package:ip4u/data_block.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _entryIPController = TextEditingController();
  final TextEditingController _entryPrefixController = TextEditingController();

  String? _userIP;
  String? _userPrefix;

  String _networkAddress = "127.0.0.0";
  String _broadcastAddress = "127.0.0.255";
  String _prefix = "255.255.255.0";
  int _hostsCount = 254;


  String _getNetworkAddress() {
    return convertIntegerToIp(
      convertIpToInteger(_userIP!)
      & convertPrefixToInteger(int.parse(_userPrefix!))
    );
  }

  String _getBroadcastAddress() {
    return convertIntegerToIp(
      convertIpToInteger(_userIP!)
      | invertNumber(convertPrefixToInteger(int.parse(_userPrefix!)))
    );
  }

  String _getPrefix() {
    return convertIntegerToIp(convertPrefixToInteger(int.parse(_userPrefix!)));
  }

  int _getSubnetCount() {
    if (int.tryParse(_userPrefix!) == null) {
      return 0;
    }

    int prefixInt = int.parse(_userPrefix!);

    if (prefixInt > 32) {
      return 0;
    }

    return pow(2, prefixInt - 24).toInt();
  }

  int _getHostsCount() {
    if (int.tryParse(_userPrefix!) == null) {
      return 0;
    }

    int prefixInt = int.parse(_userPrefix!);

    if (prefixInt > 32) {
      return 0;
    }

    int hostCount = pow(2, 32 - prefixInt).toInt();

    return hostCount > 2 ? hostCount - 2 : hostCount;
  }

  void _calculate() {
    setState(() {
      _userIP = _userIP ?? "127.0.0.1";
      _userPrefix = _userPrefix ?? "24";

      try {
        _networkAddress = _getNetworkAddress();
        _broadcastAddress = _getBroadcastAddress();
        _prefix = _getPrefix();
        _hostsCount = _getHostsCount();        
      } catch (e) {
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _entryIPController,
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: '127.0.0.1',
                        suffix: GestureDetector(
                          child: const Icon(Icons.clear),
                          onTap: () {
                            _entryIPController.clear();
                            _userIP = null;
                          },
                        )
                      ),
                      validator: (String? value) {
                        if (isEmptyValue(value)) {
                          _userIP = null;
                          return null;
                        }

                        return validateIP(value);
                      },
                      onChanged: (String? data) {
                        _userIP = data;
                      },
                    ),
                    TextFormField(
                      controller: _entryPrefixController,
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: '24',
                        suffix: GestureDetector(
                          child: const Icon(Icons.clear),
                          onTap: () {
                            _entryPrefixController.clear();
                            _userPrefix = null;
                          },
                        )
                      ),
                      validator: (String? value) {
                        if (isEmptyValue(value)) {
                          _userPrefix = null;
                          return null;
                        }
                        
                        return validatePrefix(value);
                      },
                      onChanged: (String? data) {
                        _userPrefix = data;
                      },
                    ),
                    const SizedBox(height: 50,),
                    DataBlock(
                      networkAddress: _networkAddress,
                      broadcastAddress: _broadcastAddress,
                      prefix: _prefix,
                      hostsCount: _hostsCount
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _calculate,
        label: const Text("Calculate"),
        icon: const Icon(Icons.calculate),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
