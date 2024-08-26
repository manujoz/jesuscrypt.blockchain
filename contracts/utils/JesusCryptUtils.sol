// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

import "../interfaces/AggregatorV3Interface.sol";

library JesusCryptUtils {
    address public constant CHAINLINK_BNB_USDT = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;

    function _calculateDateComponents(uint256 d, int256 offset19700101) internal pure returns (uint256, uint256, uint256) {
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

        uint256 year = uint256(_year);
        uint256 month = uint256(_month);
        uint256 day = uint256(_day);

        return (year, month, day);
    }

    function _calculateTimeComponents(
        uint256 _timestamp,
        uint256 secondsPerDay,
        uint256 secondsPerHour,
        uint256 secondsPerMinute
    ) internal pure returns (uint256, uint256, uint256, uint256) {
        uint256 d = _timestamp / secondsPerDay;
        uint256 secondsRemaining = _timestamp % secondsPerDay;

        uint256 hour = secondsRemaining / secondsPerHour;
        secondsRemaining = secondsRemaining % secondsPerHour;

        uint256 minute = secondsRemaining / secondsPerMinute;
        uint256 second = secondsRemaining % secondsPerMinute;

        return (d, hour, minute, second);
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
        AggregatorV3Interface priceFeed = AggregatorV3Interface(CHAINLINK_BNB_USDT);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function toDateTime(uint256 _timestamp) public pure returns (uint256[] memory) {
        uint256 secondsPerDay = 24 * 60 * 60;
        uint256 secondsPerHour = 60 * 60;
        uint256 secondsPerMinute = 60;
        int256 offset19700101 = 2440588;

        (uint256 d, uint256 hour, uint256 minute, uint256 second) = _calculateTimeComponents(_timestamp, secondsPerDay, secondsPerHour, secondsPerMinute);
        (uint256 year, uint256 month, uint256 day) = _calculateDateComponents(d, offset19700101);

        uint256[] memory dateTime = new uint256[](6);
        dateTime[0] = year;
        dateTime[1] = month;
        dateTime[2] = day;
        dateTime[3] = hour;
        dateTime[4] = minute;
        dateTime[5] = second;

        return dateTime;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
