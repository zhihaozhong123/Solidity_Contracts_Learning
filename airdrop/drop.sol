// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract BatchAirDrop is Ownable {

    IERC20[] public tokenAddrs;

    event BatchAirDropTokens(IERC20[] indexed tokenAddrs, address[] indexed tos, uint256 value);

    function getTokenAddrs() public view returns(IERC20[] memory) {
        return tokenAddrs;
    }

    function addTokenAddr(IERC20[] memory tokenAddrs_) public returns(bool) {
        for(uint256 i = 0; i < tokenAddrs_.length; i++) {
            tokenAddrs.push(tokenAddrs_[i]);
        }
        return true;
    }

    // 给多个用户空投固定value数量的erc20代币
    function batchAirDropTokens(address[] memory users, uint256 value) public returns(bool) {
        for(uint256 i = 0; i < tokenAddrs.length; i++) {
            for(uint256 k = 0; k < users.length; k++) {
                IERC20(tokenAddrs[i]).transferFrom(msg.sender,users[k], value);
            }
        }

        emit BatchAirDropTokens(tokenAddrs,users,value);

        return true;
    }

}
