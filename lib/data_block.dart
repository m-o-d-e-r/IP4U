import 'package:flutter/material.dart';


class DataBlock extends StatelessWidget {
  String networkAddress = "127.0.0.0";
  String broadcastAddress = "127.0.0.255";
  String prefix = "255.255.255.0";
  int hostsCount = 254;

  DataBlock(
    {
      required this.networkAddress,
      required this.broadcastAddress,
      required this.prefix,
      required this.hostsCount
    }
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Network address: "),
                Text("Broadcast address: "),
                Text("Mask: "),
                Text("Hosts count: "),
              ],
            )
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(networkAddress),
              Text(broadcastAddress),
              Text(prefix),
              Text("$hostsCount"),
            ],
          ),
        )
      ],
    );
  }
}
