// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {Fundme} from "../../src/Fundme.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {Script} from "forge-std/Script.sol";

contract Testinteractions is Test {
    Fundme fundme;
    address public USER = makeAddr("user");
    uint256 public constant SEND_VALUE = 0.01 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        DeployFundme deployFundme = new DeployFundme();
        fundme = deployFundme.run();
        vm.prank(USER);
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumusd() external view {
        uint256 minimumUsd = fundme.S_MINIMUM_USD();
        assertEq(minimumUsd, 5e15); // 0.005 ETH
    }

    function testOwner() external view {
        assertEq(fundme.getowner(), msg.sender);
    }

    function testfunders() external {
        fundme.fund{value: SEND_VALUE}();
        address funder = fundme.getFunder(0);
        assertEq(funder, USER, "The first funder should be the USER address");
    }

    function testfund() external {
        // Arrange
        uint256 startingOwnerBalance = fundme.getowner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        // Act
        vm.startPrank(USER);
        fundme.fund{value: SEND_VALUE}();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundme.getowner().balance;
        uint256 endingFundmeBalance = address(fundme).balance;
        assertEq(
            startingOwnerBalance + startingFundmeBalance,
            endingOwnerBalance
        );
        assertEq(
            endingFundmeBalance,
            SEND_VALUE,
            "The Fundme contract should have the correct balance after funding"
        );
    }

    function testwithdraw() external {
        // Arrange
        uint256 startingOwnerBalance = fundme.getowner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        // Act
        vm.startPrank(fundme.getowner());
        fundme.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundme.getowner().balance;
        uint256 endingFundmeBalance = address(fundme).balance;
        assertEq(
            startingOwnerBalance + startingFundmeBalance,
            endingOwnerBalance,
            "The owner should have the correct balance after withdrawal"
        );
        assertEq(
            endingFundmeBalance,
            0,
            "The Fundme contract should have a balance of 0 after withdrawal"
        );
    }
}
