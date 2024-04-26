import 'package:flutter/material.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late W3MService _w3mService;

  final _avalancheChain = W3MChainInfo(
      chainName: "Avalanche",
      chainId: "43114",
      namespace: "eip155:43114",
      tokenName: "AVAX",
      rpcUrl: "https://api.avax.network/ext/bc/C/rpc");
  @override
  void initState()  {
    super.initState();
    int();
  }

  void int() async {
    _w3mService  = W3MService(
      projectId: '< PROJECT ID SHOULD BE PLACED HERE >',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
      excludedWalletIds: {"fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa"},
        includedWalletIds: {}
    );

// Register callbacks on the Web3App you'd like to use. See `Events` section.

    await _w3mService.init();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                W3MNetworkSelectButton(service: _w3mService),
                W3MConnectWalletButton(service: _w3mService),
                ElevatedButton(onPressed: () async {
                  _w3mService.launchConnectedWallet();
                  final connectedAddress = _w3mService.session?.address;
                  final result = await _w3mService.request(
                    topic: _w3mService.session?.topic ?? '',
                    chainId: 'eip155:1', // Connected chain id
                    request: SessionRequestParams(
                      method: 'eth_sendTransaction',
                      params: [{
                        "from": connectedAddress,
                        "to": connectedAddress,
                        "value": "0x1"
                      }],
                    ),
                  );
                }, child: const Text("Send")),
                ElevatedButton(onPressed: () async {
                  _w3mService.launchConnectedWallet();
                  await _w3mService.request(
                    topic: _w3mService.session?.topic ?? '',
                    chainId: 'eip155:1', // Connected chain id
                    request: SessionRequestParams(
                      method: 'personal_sign',
                      params: ['Sign this', "0x3D1bf2A5EFE4be1D0EFeD337eda3a90B925Ab163"],
                    ),
                  );

                }, child: const Text("Send 2")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
