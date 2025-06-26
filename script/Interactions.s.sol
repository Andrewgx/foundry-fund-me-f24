// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        Fundme(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        console.log("Funded Fundme contract with %s wei", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );

        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    // This contract is used to withdraw funds from the Fundme contract
    // It is separate from the FundFundMe contract to demonstrate different interactions
    function withdrawFunds(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        Fundme(payable(mostRecentlyDeployed)).withdraw();
        console.log("Withdrew funds from Fundme contract");
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );

        withdrawFunds(mostRecentlyDeployed);
    }
}
