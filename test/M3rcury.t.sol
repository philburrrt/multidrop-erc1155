// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/M3rcury.sol";

contract M3rcuryTest is Test {

    M3rcury public mercury;
    string internal uri = "ipfs/QmTnqR164FVkMHXDWkVicRjaZTdaAB9LAftHKivFqAYtB9";

    function setUp() public {
        mercury = new M3rcury();
    }

    function testCreateDrop() public {
        mercury.createDrop(0, 500e15, 10, uri);
    }

    function testMint() public {
        mercury.createDrop(0, 500e15, 10, uri);
        mercury.activateSale(0);
        // address(this).deposit(500e15);
        // mercury.mint(0, 1);
        // vm.expectRevert();

    }
}
