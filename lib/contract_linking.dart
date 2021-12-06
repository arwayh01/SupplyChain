import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';
import "package:web3dart/web3dart.dart";
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:test_interface/asset.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";
  final String _privateKey ="7a1e4089b58962de4fcc1e736d2bc0134b8712c92bc440b2e2bf62bcf788545a";
  late Web3Client _client;
  late bool isLoading = true;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _asset;
  late ContractFunction _tracking;
  late ContractFunction _createAsset;
  late ContractFunction _VerifyAndTransferAsset;
  late ContractFunction _ProcessStep;
  late ContractFunction _DistributionStep;
  late ContractFunction _transferAsset;
  late ContractFunction _getAssetDetails;
  late ContractFunction _getAssetLocation;
  late ContractEvent _locations;
  late ContractEvent _assetStore;


  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {

    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {

    // Reading the contract abi
    String abiStringFile =
    await rootBundle.loadString("src/artifacts/AssetTracker.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async => _credentials = await _client.credentialsFromPrivateKey(_privateKey);

  Future<void> getDeployedContract() async {

    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "AssetTracker"), _contractAddress);

    // Extracting the functions, declared in contract.
    _asset = _contract.function("asset");
    _tracking = _contract.function("tracking");
    _createAsset = _contract.function("createAsset");
    _VerifyAndTransferAsset = _contract.function("VerifyAndTransferAsset");
    _ProcessStep = _contract.function("ProcessStep");
    _DistributionStep = _contract.function("DistributionStep");
    _transferAsset = _contract.function("transferAsset");
    _getAssetDetails = _contract.function("getAssetDetails");
    _getAssetLocation = _contract.function("getAssetLocation");
    _locations = _contract.event("locations");
    _assetStore = _contract.event("assetStore");


    //getName();

  }
//Future <String>
  addAsset(String manufactrer,String name,String description) async{
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract, function: _createAsset, parameters: [ name,description,"1"]));

  }
  /*getName() async {

    // Getting the current name declared in the smart contract.
    var currentName = await _client
        .call(contract: _contract, function: _yourName, params: []);
    deployedName = currentName[0];
    isLoading = false;
    notifyListeners();
  }

  setName(String nameToSet) async {

    // Setting the name to nameToSet(name defined by user)
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract, function: _setName, parameters: [nameToSet]));
    getName();
  }*/

}




