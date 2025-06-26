// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Helperconfig} from "./Helperconfig.s.sol";
import {Fundme} from "../src/Fundme.sol";
import {Script} from "forge-std/Script.sol";

contract DeployFundme is Script {
    function run() external returns (Fundme) {
        Helperconfig helperconfig = new Helperconfig();
        address ethpricefeed = helperconfig.activeNetworkConfig();

        vm.startBroadcast();
        Fundme fundme = new Fundme(ethpricefeed);
        vm.stopBroadcast();
        return fundme;
    }
}
