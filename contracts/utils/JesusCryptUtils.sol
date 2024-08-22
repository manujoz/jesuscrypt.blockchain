// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/AggregatorV3Interface.sol";

contract JesusCryptUtils {
    address public constant CHAINLINK_BNB_USDT = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;
    AggregatorV3Interface internal priceFeed;

    constructor() {
        // Chainlink BNB/USDT price feed
        priceFeed = AggregatorV3Interface(CHAINLINK_BNB_USDT);
    }

    /**
     * @dev Calculate SQRT price
     * @param _jsctPriceInUSDT Price of JSCP in USDT
     * @param _getForWBNB True if the price is for WBNB, false if it is for USDT
     * @return uint160 SQRT price
     */
    function _calculateSqrtPriceX96(uint256 _jsctPriceInUSDT, bool _getForWBNB) internal view returns (uint160) {
        uint256 sqrtPriceX96;

        if (_getForWBNB) {
            uint256 bnbPriceInUSDT = getLatestBNBPrice();
            uint256 jsctPriceInBNB = (_jsctPriceInUSDT * 1e18) / bnbPriceInUSDT;
            sqrtPriceX96 = _sqrt(jsctPriceInBNB) * 2 ** 96;
        } else {
            sqrtPriceX96 = _sqrt(_jsctPriceInUSDT) * 2 ** 96;
        }

        return uint160(sqrtPriceX96);
    }

    /**
     * @dev get the square root of a number
     * @param _x Number to get the square root
     * @return y Square root of the number
     * @notice This function is used to get the square root of a number
     */
    function _sqrt(uint256 _x) internal pure returns (uint256 y) {
        uint256 z = (_x + 1) / 2;
        y = _x;
        while (z < y) {
            y = z;
            z = (_x / z + z) / 2;
        }

        return y;
    }

    /**
     * @dev Get the latest BNB price
     * @return uint256 Latest BNB price
     * @notice This function is used to get the latest BNB price
     */
    function getLatestBNBPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    /**
     * @dev Parse a timestamp to a date
     * @param _timestamp Timestamp to parse
     * @return year Year of the timestamp
     * @return month Month of the timestamp
     * @return day Day of the timestamp
     * @return hour Hour of the timestamp
     * @return minute Minute of the timestamp
     * @return second Second of the timestamp
     * @notice This function is used to parse a timestamp to a date
     */
    function toDateTime(uint256 _timestamp) public pure returns (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) {
        uint256 secondsPerDay = 24 * 60 * 60;
        uint256 secondsPerHour = 60 * 60;
        uint256 secondsPerMinute = 60;
        int256 offset19700101 = 2440588;

        uint256 d = _timestamp / secondsPerDay;
        uint256 secondsRemaining = _timestamp % secondsPerDay;

        hour = secondsRemaining / secondsPerHour;
        secondsRemaining = secondsRemaining % secondsPerHour;

        minute = secondsRemaining / secondsPerMinute;
        second = secondsRemaining % secondsPerMinute;

        int256 h = int256(d) + 68569 + offset19700101;
        int256 n = (4 * h) / 146097;
        h = h - (146097 * n + 3) / 4;
        int256 _year = (4000 * (h + 1)) / 1461001;
        h = h - (1461 * _year) / 4 + 31;
        int256 _month = (80 * h) / 2447;
        int256 _day = h - (2447 * _month) / 80;
        h = _month / 11;
        _month = _month + 2 - 12 * h;
        _year = 100 * (n - 49) + _year + h;

        year = uint256(_year);
        month = uint256(_month);
        day = uint256(_day);
    }
}
