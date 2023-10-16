// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/IERC721.sol";
import "FT.sol";

contract Fractionalization{

    mapping(address => mapping(uint => bool)) public stakeNFTMapping;
    mapping(address => address) public NFTAddrToFTAddr;

    function stakeNFT(address _collectionAddr, uint _tokenId) public {
        IERC721 coll = IERC721(_collectionAddr);
        
        // check owner
        require((coll.getApproved(_tokenId) == address(this)) || (coll.isApprovedForAll(msg.sender, address(this))),"not approve");
        require(coll.ownerOf(_tokenId) == msg.sender, "not owner");
        
        // transfer nft
        coll.transferFrom(msg.sender, address(this),_tokenId);
        
        // generate FT token address
        ftAddr = createFT(_collectionAddr);

        // mint FT tokens
        FT ft = FT(ftAddr);
        stakeNFTMapping[_collectionAddr][_tokenId] = true;
        ft.mint(user,FTAmount);

    }

    function createFT(address _nftAddr) internal returns(address){
        bytes32 _salt = keccak256(
            abi.encodePacked(
                _nftAddr
            )
        );
        new FT{
            salt : bytes32(_salt)
        }
        ();
        address FTAddr = getAddress(getFTBytecode(),_salt);

         //检索lptoken
        FTAddressList.push(FTAddr);
        //isFTCreated[FTAddr] = true;
        findFT[_nftAddr] = FTAddr;
        //findLpToken[addrToken0][addrToken1] = lptokenAddr;

        return FTAddr;
    }
}
