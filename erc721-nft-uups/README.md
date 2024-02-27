# 一. ERC721 NFT

## 1. 合约升级

升级步骤

https://www.yuque.com/jackiezhong/lkrqcc/kviygqbheabxch6p?singleDoc# 《ERC721-NFT-UUPS合约升级步骤》

## 2. 合约部署

使用 https://remix.ethereum.org/ 在线代码编辑工具，勾选 Deploy with Proxy 进行部署，参数如下

```js

MERKLEROOT_: // 根哈希值
0x4d871defed228a51607c31f9c8419b314f51fa8fbd81b62f958251d9a4e888cd
_STARTTIME: // 开始时间
1709018220
_ENDTIME: // 结束时间
17090182201
_BASETOKENURI: // 基本的URI
ipfs:/com/
_BASEEXTENSION: // 元数据文本后缀
.json
_LOCKCONTRACT: // 锁仓合约地址
0x58b9bDaA6E3464f703550722109877D600DE24EC

```
## 3. 方法解释
```js

1.whitelistMint // 白名单用户铸造
参数：
["0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb","0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c","0x454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6"] // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4用户才能执行

2.treasuryMint // 管理员铸造

```

## 4. 业务需求

`每个代码中有业务需求要求的功能点，如代码注释中的需求1，需求2等`



# 二. NFTLockContract

## 1. 合约部署

使用 https://remix.ethereum.org/ 在线代码编辑工具进行部署，参数如下

```js

_LOCKTIME: // 锁仓时间
uint256
_INITIALOWNER: // 最高级owner
address
_TREASURY1: // 国库地址1
address
_TREASURY2: // 国库地址2
address

```

= 部署完记得调用setContract方法配置下NFT的合约地址 = 

## 2. 主要方法 withdraw

`国库地址可以在有效时间内提取NFT`

# 如何生成默克尔树

1. npm install

2. node merkle_generate.js

```js

MacBook-Pro Merkle_Tree_Whitelist_NFT % node merkle_tree.js 
Whitelist Merkle Tree
 └─ 4d871defed228a51607c31f9c8419b314f51fa8fbd81b62f958251d9a4e888cd
   ├─ eeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097
   │  ├─ 9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65
   │  │  ├─ 5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229
   │  │  └─ 999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb
   │  └─ 4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c
   │     ├─ 04a10bfd00977f54cc3450c9b25c9b3a502a089eba0097ba35fc33c4ea5fcb54
   │     └─ dfbe3e504ac4e35541bebad4d0e7574668e16fefa26cd4172f93e18b59ce9486
   └─ 454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6
      ├─ 0befebd5f6f5e8b5f7ec6935245efbd76ce396aedac1b12781a64df01b75aab7
      │  ├─ f6d82c545c22b72034803633d3dda2b28e89fb704f3c111355ac43e10612aedc
      │  └─ c23d89d4ba0f8b56a459710de4b44820d73e93736cfc0667f35cdd5142b70f0d
      └─ 1c22adb6b75b7a618594eacef369bc4f0ec06380e8630fd7580f9bf0ea413ca8
         └─ 1c22adb6b75b7a618594eacef369bc4f0ec06380e8630fd7580f9bf0ea413ca8

0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
[
  '0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb',
  '0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c',
  '0x454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6'
]
true
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
[
  '0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229',
  '0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c',
  '0x454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6'
]
true
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
[
  '0xdfbe3e504ac4e35541bebad4d0e7574668e16fefa26cd4172f93e18b59ce9486',
  '0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65',
  '0x454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6'
]
true
0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
[
  '0x04a10bfd00977f54cc3450c9b25c9b3a502a089eba0097ba35fc33c4ea5fcb54',
  '0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65',
  '0x454e487b2c712ea463c0a2b745cc1507a3028291057f8aa031477d77592f92f6'
]
true
0x617F2E2fD72FD9D5503197092aC168c91465E7f2
[
  '0xc23d89d4ba0f8b56a459710de4b44820d73e93736cfc0667f35cdd5142b70f0d',
  '0x1c22adb6b75b7a618594eacef369bc4f0ec06380e8630fd7580f9bf0ea413ca8',
  '0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097'
]
true
0x17F6AD8Ef982297579C203069C1DbfFE4348c372
[
  '0xf6d82c545c22b72034803633d3dda2b28e89fb704f3c111355ac43e10612aedc',
  '0x1c22adb6b75b7a618594eacef369bc4f0ec06380e8630fd7580f9bf0ea413ca8',
  '0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097'
]
true
0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678
[
  '0x0befebd5f6f5e8b5f7ec6935245efbd76ce396aedac1b12781a64df01b75aab7',
  '0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097'
]
true

```

