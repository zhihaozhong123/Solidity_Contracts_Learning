// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract New_Lottery is Initializable, OwnableUpgradeable {

    // 转账事件
    event TransferSent(address _from, address _to, uint _amount);
    
    // 奖金池
    uint public pot;
    // address是基本数据类型之一
    address public manager;
    // 数组来接收彩民
    address payable[] public players;

    // modifier关键字，代表匿名函数
    // 这里的意思是只有manager可以调用
    modifier onlyManagerCanCall() {
        require(msg.sender == manager,"Sorry, only manager of this contract can perform this task!");
        _;
    } 

    function initialize(address _manager) public initializer {
        __Ownable_init();
        manager = _manager;
    }

    function getInitializeData(address _manager) public pure returns (bytes memory) {
        return abi.encodeWithSignature("initialize(address)", _manager);
    }
    
    // 彩民投注的方法
    function enter() public payable {
        // require对函数进行限定
        // 这里表示彩民投注必须是一个以太币
        require(msg.value == 1 ether,"1 ether at least!");
        players.push(payable(msg.sender));
        pot += msg.value;
    }
    
    // 得到所有的彩民
    function getAllPlayers() public view returns(address payable[] memory) {
        return players;
    }
        
    // 查看奖金池的所有金额
    function queryPoolMoney() public view returns(uint) {
        // 用this来表示金额
        return pot;
    }
     
    // 创建一个随机数
    function random() private view returns(uint) {
        return uint256(keccak256(abi.encodePacked(block.coinbase,block.prevrandao, block.timestamp,players)));
    }

    // 通过随机数，随机产生中奖的彩民
    function pickWinner() public onlyManagerCanCall {
        uint index = random() % players.length;
        // 给彩民转账
        uint player_reward = pot / 100 * 95;
        uint manager_reward = pot / 100 * 5;

        players[index].transfer(player_reward);
        payable(manager).transfer(manager_reward);

        emit TransferSent(address(this),players[index],player_reward);
        emit TransferSent(address(this),manager,manager_reward);

        // 新的一轮，新的彩民信息
        // players = new address payable[](0);
        delete players;

        pot = 0;
    }    

}
