// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {priceconverter} from "./priceconverter.sol";

using priceconverter for uint256;

error Fundme__NotOwner();

contract Fundme {
    using priceconverter for uint256;

    uint256 public constant S_MINIMUM_USD = 5e15; // 0.005 ETH
    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;
    AggregatorV3Interface public s_priceFeed;

    address public immutable i_owner;

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= S_MINIMUM_USD,
            "You need to spend more ETH!"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Fundme__NotOwner();
        }
        _;
    }

    function getversion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function withdraw() public onlyOwner {
        uint256 funderslength = s_funders.length;
        address[] memory funders = s_funders;
        for (
            uint256 fundersindex = 0;
            fundersindex < funderslength;
            fundersindex++
        ) {
            address funder = funders[fundersindex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // withdraw the funds
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function getowner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }
}
