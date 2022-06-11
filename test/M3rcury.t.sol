// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/M3rcury.sol";

contract M3rcuryTest is Test {

    M3rcury public mercury;
    string internal uri = "ipfs/QmTnqR164FVkMHXDWkVicRjaZTdaAB9LAftHKivFqAYtB9";

    address testContract;
    address mercuryContract;
    address testContractOwner;
    address mercuryContractOwner;

    address owner;
    address msgSender;

    //prank makes mercury's owner == msg.sender, which is the default account

    function setUp() public {
        owner = msg.sender;
        vm.prank(owner);
        mercury = new M3rcury();
    }

    // function testAddresses() public returns (address[5] memory) {
        
    //     testContract = address(this);
    //     mercuryContract = address(mercury);
    //     testContractOwner = owner;
    //     mercuryContractOwner = mercury.owner();
    //     msgSender = address(msg.sender);
        

    //     return [
    //         testContract,
    //         mercuryContract,
    //         testContractOwner,
    //         mercuryContractOwner,
    //         msgSender
    //     ];

    // }

    function testMint() public returns(uint256) {
        vm.startPrank(owner);
        mercury.createDrop(0, 500e15, 10, uri);
        mercury.activateSale(0);
        mercury.mint{value: 500e15}(0, 1);
        assert(mercury.balanceOf(owner, 0) == 1);
        assert(address(mercury).balance == 500e15);
        mercury.withdraw();
        vm.stopPrank();
    }
}
