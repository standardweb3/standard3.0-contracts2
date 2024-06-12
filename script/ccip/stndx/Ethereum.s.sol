// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockBTC} from "../../../src/mock/MockBTC.sol";
import {MockToken} from "../../../src/mock/MockToken.sol";
import {MatchingEngine} from "../../../src/exchange/MatchingEngine.sol";
import {OrderbookFactory} from "../../../src/exchange/orderbooks/OrderbookFactory.sol";
import {Orderbook} from "../../../src/exchange/orderbooks/Orderbook.sol";
import {Multicall3} from "../../Multicall3.sol";
import {TokenDispenser} from "../../../src/exchange/airdrops/TokenDispenser.sol";
import {ExchangeOrderbook} from "../../../src/exchange/libraries/ExchangeOrderbook.sol";
import {ERC20MintablePausableBurnable} from "../../../src/stnd/ccip/STNDX.sol";

contract Deployer is Script {
    function _setDeployer() internal {
        uint256 deployerPrivateKey = vm.envUint("LINEA_TESTNET_DEPLOYER_KEY");
        vm.startBroadcast(deployerPrivateKey);
    }
}

contract DeployMulticall3 is Deployer {
    function run() external {
        _setDeployer();
        new Multicall3();
        vm.stopBroadcast();
    }
}

contract DeployERC20MintablePausableBurnable is Deployer {
    ERC20MintablePausableBurnable public stnd;
    function run() external {
        _setDeployer();
        stnd = new ERC20MintablePausableBurnable();
        vm.stopBroadcast();
    }
}

contract GrantMinterRole is Deployer {
    address stnd_address = 0x7a2e3a7A1bf8FaCCAd68115DC509DB5a5af4e7e4;
    ERC20MintablePausableBurnable public stnd;
    address minter = address(0);
    function run() external {
        _setDeployer();
        stnd = ERC20MintablePausableBurnable(stnd_address);
        stnd.grantRole(stnd.MINTER_ROLE(), minter);
    }
}