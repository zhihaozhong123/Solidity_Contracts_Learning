// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Airdrop is Ownable {
    
    event emergencyWithdrawEth(address _address,uint256 _amount);

    IERC20 public VOKEN;

    constructor(address _token) {
        VOKEN = IERC20(_token);
    }

    // 转以太坊到当前合约
    function enter() public payable onlyOwner {
        require(msg.value == 1 ether,"1 ether is needed!");
    }

    // 批量转ETH和Token
    function batchTransfer(address payable[] memory accounts, uint256 etherValue, uint256 vokenValue) public payable onlyOwner {
        uint256 _etherBalance = address(this).balance;
        uint256 _vokenAllowance = VOKEN.allowance(msg.sender, address(this));

        require(_etherBalance >= etherValue * (accounts.length));
        require(_vokenAllowance >= vokenValue * (accounts.length));

        // 转账
        for (uint256 i = 0; i < accounts.length; i++) {
            accounts[i].transfer(etherValue);
            assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
        }
    }

   /**
     * 批量转出前合约必须要有以太坊，如果没有以太坊，首先执行上面的enter回退函数，给合约转账对应的以太坊,等合约有了以太坊才可以执行批量转账以太坊的操作
     *  uint256 这是以一个转以太坊的操作,应该是独有的方法,所以这也是xxxx.transfer(合约的以太坊也只能是合约的以太坊的值)
     * @dev Batch transfer Ether.
     */
    function batchTtransferEther(address payable[] memory accounts, uint256 etherValue) public payable onlyOwner {
        uint256 _etherBalance = address(this).balance;

        require(_etherBalance >= etherValue * (accounts.length));

        for (uint256 i = 0; i < accounts.length; i++) {
            accounts[i].transfer(etherValue);
        }
    }

    /**
     * 批量转出代币前,首先必须approve授权当前的 BatchTransferEtherAndVoken合约,然后授予多少转账token额度,然否token.transferFrom(from,to,value)中的参数from也必须要有token,也必须要足够量，
     * 如果要取消授权也就是再次执行approve，必须先将approve(_spender,0),将授权额度更改成0，然后才能再次执行授权
     * @dev Batch transfer Voken.
     */
    function batchTransferVoken(address[] memory accounts, uint256 vokenValue) public onlyOwner {
        uint256 _vokenAllowance = VOKEN.allowance(msg.sender, address(this));

        require(_vokenAllowance >= vokenValue * (accounts.length));

        for (uint256 i = 0; i < accounts.length; i++) {
            // assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue*10**21));
            assert(VOKEN.transferFrom(msg.sender, accounts[i], vokenValue));
        }
    }

    // 提取合约内部所有的eth
    function emergencyWithdrawAllETH() payable external onlyOwner {
        _emergencyWithdrawAllETH();
        emit emergencyWithdrawEth(msg.sender,msg.value);
    }

    // 获取账户的eth余额
    function getEthBalanceByAddress(address _address) public view returns(uint256) {
        return _address.balance;
    }

    // 提取合约内部所有的eth
    function _emergencyWithdrawAllETH() private {
        payable(address(msg.sender)).transfer(address(this).balance);
    }


}

contract Airdrop2 {

    IERC20[] public tokenAddrs;

    event BatchAirDropTokens(IERC20[] indexed tokenAddrs, address[] indexed tos, uint256 value);

    // 获取代币的合约地址
    function getTokenAddrs() public view returns(IERC20[] memory) {
        return tokenAddrs;
    }

    // 添加需要空投的代币的合约地址
    function addTokenAddr(IERC20[] memory tokenAddrs_) public returns(bool) {
        for(uint256 i = 0; i < tokenAddrs_.length; i++) {
            tokenAddrs.push(tokenAddrs_[i]);
        }
        return true;
    }

    // 将不同的代币空投给多个用户，空投的是固定数量的erc20代币
    function batchAirDropTokens(address[] memory users, uint256 value) public returns(bool) {
        for(uint256 i = 0; i < tokenAddrs.length; i++) {
            for(uint256 k = 0; k < users.length; k++) {
                IERC20(tokenAddrs[i]).transfer(users[k], value);
            }
        }
        emit BatchAirDropTokens(tokenAddrs,users,value);
        return true;
    }



}
