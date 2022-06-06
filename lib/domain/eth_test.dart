import 'package:collection/collection.dart';

class EthTestAccount {
  static const ETH_CHAIN = "eip155";

  static List<EthChains> listChains() {
    return [
      EthChains("Ethereum", ETH_CHAIN, "1",
          "0x022c0c42a80bd19EA4cF0F94c4F9F96645759716"),
      EthChains("Polygon Matic", ETH_CHAIN, "137",
          "0x022c0c42a80bd19EA4cF0F94c4F9F96645759716"),
      EthChains("Ethereum Kovan", ETH_CHAIN, "42",
          "0x022c0c42a80bd19EA4cF0F94c4F9F96645759716"),
      EthChains("Optimism Kovan", ETH_CHAIN, "69",
          "0xf5de760f2e916647fd766b4ad9e85ff943ce3a2b"),
      EthChains("Polygon Mumbai", ETH_CHAIN, "80001",
          "0x5A9D8a83fF2a032123954174280Af60B6fa32781"),
      EthChains("Arbitrum Rinkeby", ETH_CHAIN, "421611",
          "0x682570add15588df8c3506eef2e737db29266de2"),
      EthChains("Celo Alfajores", ETH_CHAIN, "44787",
          "0xdD5Cb02066fde415dda4f04EE53fBb652066afEE"),
    ];
  }

  static EthChains? findAccount(String name) {
    var res = listChains().firstWhereOrNull(
        (e) => name == "${e.chainNamespace}:${e.chainReference}");
    return res;
  }
}

class EthChains {
  final String chainName;
  final String chainNamespace;
  final String chainReference;
  final String addressAccount;

  EthChains(this.chainName, this.chainNamespace, this.chainReference,
      this.addressAccount);
}
