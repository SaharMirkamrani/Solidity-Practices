// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract SimpleNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Simple NFT", "SNFT") {}

    function totalSupply() public view returns(uint) {
        _tokenIds.current();
    }

    function contractURI() public pure returns(string memory) {
        return "JSON link to contract";
    }

    function mintItem(address minter, string memory tokenURI)
    public onlyOwner returns(uint) {
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();
        _mint(minter, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}