// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library priceconverter {
    function getprice(
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        (, int256 price, , , ) = pricefeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        uint256 ethprice = getprice(pricefeed);
        return (ethprice * ethAmount) / 1e18;
    }
}
