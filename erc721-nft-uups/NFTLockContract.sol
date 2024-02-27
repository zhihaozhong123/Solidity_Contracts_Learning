// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTLockContract is IERC721Receiver, Ownable {

    event Withdraw(address indexed user, uint256 tokenId);

    IERC721 public Contract;

    // 锁仓时间 
    uint256 public lockTime;
    // 锁仓结束时间
    uint256 public endTime;

    // 国库地址
    address public treasury1;
    address public treasury2;

    constructor(
        uint256 _lockTime,
        address _initialOwner,
        address _treasury1,
        address _treasury2
        ) Ownable(_initialOwner) {
        treasury1 = _treasury1;
        treasury2 = _treasury2;
        // 锁仓结束时间 = 当前时间 + 锁仓时间
        endTime = block.timestamp + _lockTime;
    }
  
    // 提取
    function withdraw(uint256 tokenId) external {
        // 必须到结束时间才能领取
        require(block.timestamp >= endTime, "Lock period has not ended yet");
        // 只有国库地址能领取
        require(msg.sender == treasury1 || msg.sender == treasury2,"not treasury,not allowed!");

        Contract.safeTransferFrom(address(this), msg.sender, tokenId);

        emit Withdraw(msg.sender, tokenId);
    }

    // 更新锁仓时间 
    function setLockTime(uint256 _lockTime) external onlyOwner {
        lockTime = _lockTime;
    }

    // 配置合约地址
    function setContract(address _contract) external returns(IERC721) {
        Contract = IERC721(_contract);
        return Contract;
    }

    function onERC721Received(address, address, uint256, bytes memory) external virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

