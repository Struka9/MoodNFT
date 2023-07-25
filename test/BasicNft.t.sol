// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft private deployer;
    BasicNFT private nft;
    address owner = makeAddr("BOB");
    string private PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        nft = deployer.run();
    }

    function testNameIsCorrect() external view {
        string memory expectedName = "Dogie";
        string memory actualName = nft.name();
        bytes memory expectedNamePacked = abi.encodePacked(expectedName);
        bytes memory actualNamePacked = abi.encodePacked(actualName);

        assert(keccak256(expectedNamePacked) == keccak256(actualNamePacked));
    }

    function testCanMintAndHaveABalance() external {
        vm.prank(owner);
        nft.minNft(PUG_URI);
        uint256 firstTokenId = 0;
        assertEq(nft.ownerOf(firstTokenId), owner);
        assertEq(
            keccak256(abi.encodePacked(PUG_URI)),
            keccak256(abi.encodePacked(nft.tokenURI(firstTokenId)))
        );
    }
}
