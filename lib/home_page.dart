import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ip4u/utils.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _userIP;
  String? _userPrefix;

  String _networkAddress = "127.0.0.0";
  String _broadcastAddress = "127.0.0.255";
  String _prefix = "255.255.255.0";
//  int _subnetsCount = 1;
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

    return pow(2, 32 - prefixInt).toInt() - 2;
  }

  void _calculate() {
    setState(() {
      _userIP = _userIP ?? "127.0.0.1";
      _userPrefix = _userPrefix ?? "24";

      try {
        _networkAddress = _getNetworkAddress();
        _broadcastAddress = _getBroadcastAddress();
        _prefix = _getPrefix();
//        _subnetsCount = _getSubnetCount();
        _hostsCount = _getHostsCount();        
      } catch (e) {
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double mainBodyWidth = appWidth * 0.8;

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
              width: mainBodyWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '127.0.0.1',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          _userIP = null;
                          return null;
                        }

                        RegExp ipRegExp = RegExp(r"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");

                        if (ipRegExp.matchAsPrefix(value) == null) {
                          return "Please enter a valid ip address";
                        }
                        return null;
                      },
                      onChanged: (String? data) {
                        _userIP = data;
                      },
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '24',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          _userPrefix = null;
                          return null;
                        }

                        if (int.tryParse(value) == null) {
                          return "Please enter a valid net prefix";
                        } else if (int.parse(value) < 8 || int.parse(value) > 32) {
                          return "Please enter a valid net prefix";
                        }

                        return null;
                      },
                      onChanged: (String? data) {
                        _userPrefix = data;
                      },
                    ),
                    const SizedBox(height: 50,),
                    Container(
                      width: mainBodyWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Network address: "),
                                  Text("Broadcast address: "),
                                  Text("Mask: "),
//                                  Text("Subnetworks count: "),
                                  Text("Hosts count: "),
                                ],
                              ),
                              Container(
                                width: mainBodyWidth / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(_networkAddress),
                                    Text(_broadcastAddress),
                                    Text(_prefix),
  //                                  Text("$_subnetsCount"),
                                    Text("$_hostsCount"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
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
