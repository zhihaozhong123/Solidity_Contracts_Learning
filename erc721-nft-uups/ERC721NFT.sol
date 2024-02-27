// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

// ERC721 NFT
// 需求10:使用UUPS实现合约升级
contract ERC721NFT is ERC721URIStorageUpgradeable, UUPSUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using Strings for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private changeId;

    // 铸造日志
    event Mint(address indexed _account, uint256 indexed _value);

    bytes32 private merkleRoot;
    // 需求1: 限量版ERC721 NFT 总量为 999
    uint256 private constant _totalSupply = 999;
    uint256 private startTime;
    uint256 private endTime;

    uint256 public MintedCount; // 已铸造的 NFT 数量
    // 需求2:白名单用户最大可铸造数量700个
    uint256 public constant maxWhitelistMintCount = 700; // 白名单用户最大可铸造数量
    uint256 public constant maxMint2PerWallet = 60; // 国库钱包地址最大每次可铸造数量

    // 国库地址
    // 需求6:预留2个地址作为项目方的国库
    address public treasury1;
    address public treasury2;
    // 锁仓地址
    address public lockContract;

    string public baseTokenURI;
    string public  baseExtension;

    mapping(address => bool) public _hasMinted; // 用户是否已铸造
    mapping(uint256 => bool) public _mintedTokens; // 代币是否被铸造
    
    modifier onlyTreasury {
        require(treasury1 != address(0x0) || treasury2!= address(0x0),"treasury not zero");
        require(msg.sender == treasury1 || msg.sender == treasury2, "You are not authorized to use mint2");
        _;
    }

    function initialize(
        bytes32 merkleRoot_, 
        uint256 _startTime,
        uint256 _endTime,
        string calldata _baseTokenURI,
        string calldata _baseExtension,
        address _lockContract
        ) initializer public {
        require(bytes(_baseTokenURI).length != 0 || bytes(_baseExtension).length != 0,"not zero");
        require(_startTime < _endTime,"start time not bigger than end time");

        lockContract = _lockContract;

        __ERC721_init("MyNFT", "MNFT");
        __ERC721URIStorage_init();
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);

        merkleRoot = merkleRoot_;

        // 需求3: 提前设置mint开始和结束时间
        startTime = _startTime;
        endTime = _endTime;

        baseTokenURI = _baseTokenURI;
        baseExtension = _baseExtension;
    }

    /**
     *   ==============白名单用户铸造====================
     */

    // 需求4: 只有在白名单里的钱包地址才可以mint
    function whitelistMint(bytes32[] calldata proof) external nonReentrant {
        uint256 newTokenId = _getNextTokenId();
        // 时间到了才能开始铸造
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Minting is not allowed at this time");
        // 保证库存充足
        require(newTokenId <= _totalSupply, "No more tokens left to mint");
        // 当前用户是否已经铸造过了
        // 需求5: 每个地址都只能mint一个NFT
        require(!_hasMinted[msg.sender], "You have already minted an NFT");
        // 白名单用户最大铸造量不能超过maxWhitelistMintCount
        require(MintedCount < maxWhitelistMintCount, "reached the maximum allowed minting count");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        require(MerkleProof.verify(proof, merkleRoot, leaf),"Invalid Merkle Proof.");

        _mint(msg.sender, newTokenId);
        _incrementTokenId();
        MintedCount++;

        _hasMinted[msg.sender] = true;
        _mintedTokens[newTokenId] = true;

        emit Mint(msg.sender,newTokenId);
    }

    /**
     *   ==============管理员铸造====================
     */

    // 需求7: 管理员可以批量mint多个NFT
   function treasuryMint() external onlyTreasury nonReentrant {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Minting is not allowed at this time");
        // 如果可被铸造的量不够一次性铸造maxMint2PerWallet，就不能再铸造了
        require(_totalSupply - MintedCount >= maxMint2PerWallet, "limited 999....");
        // 需求8: 管理员的2个地址分别都支持一次性铸造60个NFT
        for (uint256 i = 0; i < maxMint2PerWallet; i++) {
            uint256 newTokenId = _getNextTokenId();
            // 需求9: 支持软质押(实际上是将铸造出来的NFT流转到锁仓合约进行锁定)
            _mint(lockContract, newTokenId);
            _incrementTokenId();
            MintedCount++;

            _hasMinted[msg.sender] = true;
            _mintedTokens[newTokenId] = true;

            emit Mint(msg.sender,newTokenId);
        }
    }

    /**
     *   ==============更新方法相关====================
     */

    function totalSupply() pure external returns(uint256) {
        return _totalSupply;
    }

    function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner returns(string memory) {
        return baseTokenURI = _baseTokenURI;
    }

    function setBaseExtension(string calldata _baseExtension) external onlyOwner returns(string memory){
        return baseExtension = _baseExtension;
    }

    function setTreasury1(address _treasury1) external onlyOwner returns(address) {
        return treasury1 = _treasury1;
    }

    function setTreasury2(address _treasury2) external onlyOwner returns(address) {
        return treasury2 = _treasury2;
    }

    function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
        merkleRoot = merkleRoot_;
    }

    /**
     *   ==============其它方法====================
     */

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_mintedTokens[tokenId], "Token has not been minted yet");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(),baseExtension));
    }

    // 基于定义的_currentTokenId计算出下一个token的id
    function _getNextTokenId() private view returns (uint256) {
        return changeId.current() + 1;
    }

    function _incrementTokenId() private {
        changeId.increment();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

}


