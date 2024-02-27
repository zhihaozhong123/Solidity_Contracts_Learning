// https://medium.com/@ItsCuzzo/using-merkle-trees-for-nft-whitelists-523b58ada3f9
//
// 1. Import libraries. Use `npm` package manager to install
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// 2. Collect list of wallet addresses from competition, raffle, etc.
// Store list of addresses in some data sheeet (Google Sheets or Excel)
let whitelistAddresses = [
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
    "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
    "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
    "0x17F6AD8Ef982297579C203069C1DbfFE4348c372",
    "0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678",
  ];


// 3. Create a new array of `leafNodes` by hashing all indexes of the `whitelistAddresses`
// using `keccak256`. Then creates a Merkle Tree object using keccak256 as the algorithm.
//
// The leaves, merkleTree, and rootHas are all PRE-DETERMINED prior to whitelist claim
const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

// 4. Get root hash of the `merkleeTree` in hexadecimal format (0x)
// Print out the Entire Merkle Tree.
const rootHash = merkleTree.getRoot();
console.log('Whitelist Merkle Tree\n', merkleTree.toString());

// ***** ***** ***** ***** ***** ***** ***** ***** //

// CLIENT-SIDE: Use `msg.sender` address to query and API that returns the merkle proof
// required to derive the root hash of the Merkle Tree

// ✅ Positive verification of address
const a = leafNodes[0];
const b = leafNodes[1];
const c = leafNodes[2];
const d = leafNodes[3];
const e = leafNodes[4];
const f = leafNodes[5];
const g = leafNodes[6];
// ❌ Change this address to get a `false` verification
// const claimingAddress = keccak256("0X5B38DA6A701C568545DCFCB03FCB875F56BEDDD6");

// `getHexProof` returns the neighbour leaf and all parent nodes hashes that will
// be required to derive the Merkle Trees root hash.for(const i=0;i < leafNodes.length;i++) {}

const ahexproof = merkleTree.getHexProof(a);
console.log(whitelistAddresses[0])
console.log(ahexproof);
// ✅ - ❌: Verify is claiming address is in the merkle tree or not.
// This would be implemented in your Solidity Smart Contract
console.log(merkleTree.verify(ahexproof, a, rootHash,"\n"));


const bhexproof = merkleTree.getHexProof(b);
console.log(whitelistAddresses[1])
console.log(bhexproof);
console.log(merkleTree.verify(bhexproof, b, rootHash,"\n"));


const chexproof = merkleTree.getHexProof(c);
console.log(whitelistAddresses[2])
console.log(chexproof);
console.log(merkleTree.verify(chexproof, c, rootHash,"\n"));

const dhexproof = merkleTree.getHexProof(d);
console.log(whitelistAddresses[3])
console.log(dhexproof);
console.log(merkleTree.verify(dhexproof, d, rootHash,"\n"));


const ehexproof = merkleTree.getHexProof(e);
console.log(whitelistAddresses[4])
console.log(ehexproof);
console.log(merkleTree.verify(ehexproof, e, rootHash,"\n"));

const fhexproof = merkleTree.getHexProof(f);
console.log(whitelistAddresses[5])
console.log(fhexproof); 
console.log(merkleTree.verify(fhexproof, f, rootHash,"\n"));


const ghexproof = merkleTree.getHexProof(g);
console.log(whitelistAddresses[6])
console.log(ghexproof);
console.log(merkleTree.verify(ghexproof, g, rootHash,"\n"));





