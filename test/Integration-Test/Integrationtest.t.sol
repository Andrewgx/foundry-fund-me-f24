// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {Fundme} from "../../src/Fundme.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract Integrationtest is Test {
    Fundme fundme;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        DeployFundme deployFundme = new DeployFundme();
        fundme = deployFundme.run();
    }

    function testusercanfundInteraction() public {
        FundFundMe newfundFundMe = new FundFundMe();
        vm.deal(address(newfundFundMe), STARTING_BALANCE);
        newfundFundMe.fundFundMe(address(fundme));

        address funder = fundme.getFunder(0);
        assertEq(
            funder,
            address(newfundFundMe),
            "The user should be the first funder"
        );
    }

    function testUsercanWithdrawInteraction() public {
        FundFundMe newfundFundMe = new FundFundMe();
        vm.deal(address(newfundFundMe), STARTING_BALANCE);
        newfundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe newWithdrawFundMe = new WithdrawFundMe();
        newWithdrawFundMe.withdrawFunds(address(fundme));

        assertEq(
            address(fundme).balance,
            0,
            "The Fundme contract should have a balance of 0 after withdrawal"
        );
    }
}
