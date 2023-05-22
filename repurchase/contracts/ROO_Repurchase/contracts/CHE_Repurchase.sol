pragma solidity ^0.6.12;

import "./library/Ownable.sol";
import "./library/SafeMath.sol";
import "./library/SafeERC20.sol";
import "./library/EnumerableSet.sol";
import "./interface/IBxhPair.sol";

contract Repurchase is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _caller;

    /*mdex*/
    // address public constant USDT = 0xa71EdC38d189767582C38A3145b5873052c3e47a;
    // address public constant MDX = 0x25D2e80cB6B86881Fd7e07dd263Fb79f4AbE033c;
    // address public constant MDX_USDT = 0x615E6285c5944540fd8bd921c9c8c56739Fd1E13;
    // address public constant destroyAddress = 0xF9852C6588b70ad3c26daE47120f174527e03a25; // BlackHole合约地址

    /*okex testnet*/
    // address public constant USDT = 0xe579156f9dEcc4134B5E3A30a24Ac46BB8B01281;
    // address public constant CHE = 0xD7A07aB45D2832D77A9Bde5D1f437A60292c5d7F;
    // address public constant CHE_USDT = 0x3E94409fe0B6fEaacaF145B7859A76a4b33d793F;
    // address public constant destroyAddress = 0x000000000000000000000000000000000000dEaD; // 回购地址
    // address public emergencyAddress; // 账户地址
    // uint256 public amountIn; // 5000000000000000000000 根据代币的精度决定小数位

    /*heco mainnet*/
    //    address public constant USDT = 0xa71EdC38d189767582C38A3145b5873052c3e47a;
    //    address public constant ROO = 0xADdEb3A8fB46DDc3feE55085b6AD8DaB4C4fC771;
    //    address public constant ROO_USDT = 0xC05bb03bB7bFEB243EF364F544c81dD9a07040a2;
    //    address public constant destroyAddress = 0x000000000000000000000000000000000000dEaD; // 回购地址
    //    address public emergencyAddress; // 账户地址
    //    uint256 public amountIn; // 5000000000000000000000 根据代币的精度决定小数位

    address public constant USDT = 0x7f9Ee0245D3Be4bb8F79e9fCafeD81d34C8A623D;
    address public constant CHE = 0x0d57285Ed72b1Db83f497bDBE95C25738D10a8E6;
    address public constant CHE_USDT = 0x87B2Cc033901C512306F011A4CC70461584dcCd9;
    address public constant destroyAddress = 0x000000000000000000000000000000000000dEaD; // 回购地址 
    address public emergencyAddress; // 账户地址 
    uint256 public amountIn; // 5000000000000000000000 根据代币的精度决定小数位 


    function setAmountIn(uint256 _newIn) public onlyOwner {
        amountIn = _newIn;
    }

    function setEmergencyAddress(address _newAddress) public onlyOwner {
        require(_newAddress != address(0), "Is zero address");
        emergencyAddress = _newAddress;
    }

    function addCaller(address _newCaller) public onlyOwner returns (bool) {
        require(_newCaller != address(0), "NewCaller is the zero address");
        return EnumerableSet.add(_caller, _newCaller);
    }

    function delCaller(address _delCaller) public onlyOwner returns (bool) {
        require(_delCaller != address(0), "DelCaller is the zero address");
        return EnumerableSet.remove(_caller, _delCaller);
    }

    function getCallerLength() public view returns (uint256) {
        return EnumerableSet.length(_caller);
    }

    function isCaller(address _call) public view returns (bool) {
        return EnumerableSet.contains(_caller, _call);
    }

    function getCaller(uint256 _index) public view returns (address){
        require(_index <= getCallerLength() - 1, "index out of bounds");
        return EnumerableSet.at(_caller, _index);
    }

    function swap() external onlyCaller returns (uint256 amountOut){
        require(IERC20(USDT).balanceOf(address(this)) >= amountIn, "Insufficient contract balance");
        (uint256 reserve0, uint256 reserve1,) = IBxhPair(CHE_USDT).getReserves();
        uint256 amountInWithFee = amountIn.mul(997); // 1000000000000000000*997
        // 1*997*0.5/2*1000+（1*997）
        amountOut = amountIn.mul(997).mul(reserve0) / reserve1.mul(1000).add(amountInWithFee); // 0.997
        IERC20(USDT).safeTransfer(CHE_USDT, amountIn);
        IBxhPair(CHE_USDT).swap(amountOut, 0, destroyAddress, new bytes(0));
    }

    modifier onlyCaller() {
        require(isCaller(msg.sender), "Not the caller");
        _;
    }

    function emergencyWithdraw(address _token) public onlyOwner {
        require(IERC20(_token).balanceOf(address(this)) > 0, "Insufficient contract balance");
        IERC20(_token).transfer(emergencyAddress, IERC20(_token).balanceOf(address(this)));
    }
} 