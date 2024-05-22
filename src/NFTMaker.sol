// // SPDX-License-Identifier: GPL-3.0

// pragma solidity >=0.8.2 <0.9.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// // import "@ERC721A/contracts/ERC721A.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "forge-std/console.sol";
// import "@openzeppelin/contracts/interfaces/IERC20.sol";
// import "./bid.sol";
// import "./inft.sol";

// contract SingularNFTMaker is ERC721URIStorage, Ownable, ISingularNFTMaker {
//     IERC20 public WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
//     address creator = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
//     uint256 public constant MINT_PRICE = 1 gwei;
//     mapping(address => uint256) private approvedAddresses;
//     mapping(address whiteListedAddress => uint8[] indexes) private rarityIndex;
//     mapping(uint256 tokenId => uint256 tokenPrice) private pricesOfNfts;
//     // mapping(uint256 tokenId => BID bid) private bids;
//     uint8[] private rarity;
//     string[] private nftURIs;
//     uint8[] private rangedRarity;
//     uint256 private lastTokenId = 1;

//     constructor(string memory nftName, string memory nftSymbol, uint8[] memory _rarity, string[] memory _nftURIs)
//         payable
//         ERC721(nftName, nftSymbol)
//         Ownable(msg.sender)
//     {
//         if (msg.value < MINT_PRICE) {
//             payable(msg.sender).transfer(msg.value);
//             assert(false);
//         }

//         require(rarity.length == nftURIs.length, "Rarity and nftURI need to have the same length");
//         uint8 sum = 0;
//         for (uint256 i = 0; i < _rarity.length; i++) {
//             require(_rarity[i] > 0, "Rarity values must be greator than zero");
//             sum = sum + _rarity[i];
//             rangedRarity.push(sum);
//         }

//         require(sum == uint8(100), string.concat("Sum of rarities must equal 100, got:", Strings.toString(sum)));

//         require(payable(creator).send(MINT_PRICE), "Failed to transfer funds");
//         rarity = _rarity;
//         nftURIs = _nftURIs;
//         // _mint(msg.sender, lastTokenId);
//         // _setTokenURI(lastTokenId, nftTokenURI);
//     }
//     // M9
//     // M2 F2

//     // https://gateway.pinata.cloud/ipfs/QmWQbcyPiNHgWRqPUe1YTP476p9Y1qVomjME3tyDzNAkEe

//     function whiteListAddresses(address[] memory addresses) public onlyOwner {
//         for (uint256 index = 0; index < addresses.length; index++) {
//             // require(addresses[index]!=address(0),"Invalid address");
//             if (addresses[index] != address(0)) {
//                 approvedAddresses[addresses[index]] = approvedAddresses[addresses[index]] + 1;
//                 uint8 generatedRarityIndex = getRarityIndex(generateRandgedRarityIndex(addresses[index]));

//                 rarityIndex[addresses[index]].push(generatedRarityIndex);
//             }
//         }
//     }

//     function isApproved(address nftOwner) public view returns (bool) {
//         return approvedAddresses[nftOwner] > 0;
//     }

//     function countApproved(address nftOwner) public view returns (uint256) {
//         return approvedAddresses[nftOwner];
//     }

//     function mintNew(address nftOwner) public payable returns (bool) {
//         require(approvedAddresses[nftOwner] > 0, "You have not been approved as an owner");
//         require(rarityIndex[nftOwner].length > 0, "You don't have any nft to mint");
//         require(payable(owner()).send(getMintPrice(nftOwner)), "Failed to transfer required funds");

//         uint256 currentTokenId = lastTokenId + 1;
//         uint8 nftRarityIndex = rarityIndex[nftOwner][rarityIndex[nftOwner].length - 1];
//         _mint(nftOwner, currentTokenId);
//         _setTokenURI(currentTokenId, nftURIs[nftRarityIndex]);
//         lastTokenId = currentTokenId;
//         approvedAddresses[nftOwner] = approvedAddresses[nftOwner] - 1;
//         rarityIndex[nftOwner].pop();
//         return true;
//     }

//     function getMintPrice(address nftOwner) public view returns (uint256) {
//         return MINT_PRICE / rarity[rarityIndex[nftOwner][rarityIndex[nftOwner].length - 1]];
//     }

//     function generateRandgedRarityIndex(address addr) private view returns (uint8) {
//         uint256 rand = (uint256(keccak256(abi.encodePacked(block.timestamp, addr, block.difficulty))) + 1) % 100;
//         return uint8(rand + 1);
//     }

//     function getRarityIndex(uint8 _rangedIndex) private view returns (uint8 _rarityIndex) {
//         require(_rangedIndex > 0, "Randged Index must be greater than zero");
//         for (uint256 i = 0; i < rangedRarity.length; i++) {
//             if (_rangedIndex <= rangedRarity[i]) {
//                 return uint8(i);
//             }
//         }
//         return uint8(rangedRarity.length - 1);
//     }

//     function setNftPrice(uint256 price, uint256 tokenId) public returns (bool) {
//         require(_ownerOf(tokenId) == msg.sender, "You are not the owner of the NFT");
//         pricesOfNfts[tokenId] = price;
//         return true;
//     }

//     // function setNftMinimumPrice(uint256 price, uint256 tokenId)publi

//     function approveNftSell(uint256 tokenId, address buyer) public {
//         _approve(buyer, tokenId, msg.sender);
//         emit ApprovedNFTSell(tokenId, buyer);
//     }

//     function getNftPrice(uint256 tokenId) public view returns (uint256) {
//         require(pricesOfNfts[tokenId] > 0, "Nft Not for sale");
//         return pricesOfNfts[tokenId];
//     }

//     // function placeBid

//     function buyNft(uint256 tokenId) public payable returns (bool) {
//         uint256 priceofNft = pricesOfNfts[tokenId];
//         require(priceofNft > 0, "Nft Not for sale");
//         require(msg.value < priceofNft, "Invalid Price");
//         _transfer(ownerOf(tokenId), msg.sender, tokenId);
//         payable(msg.sender).transfer(msg.value);
//         pricesOfNfts[tokenId] = 0;
//         return true;
//     }
// }

// contract MultipleNFTMaker is ERC721A, Ownable {
//     string nftTokenURI;

//     constructor(
//         string memory nftName,
//         string memory nftSymbol,
//         address nftOwner,
//         uint256 quantity,
//         string memory _nftTokenURI
//     ) payable ERC721A(nftName, nftSymbol) Ownable(msg.sender) {
//         _mint(msg.sender, quantity);
//         nftTokenURI = _nftTokenURI;
//         _baseURI();
//     }

//     function _baseURI() internal view override returns (string memory) {
//         return nftTokenURI;
//     }
// }