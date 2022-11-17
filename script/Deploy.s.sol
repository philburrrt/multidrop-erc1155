// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Drops} from "src/Drops.sol";

contract Deploy is Script {
    address owner = 0x7789818791c12a2633e88d46457230bC1D9cd110; // your address here

    function setUp() public {}

    function run() public {
        vm.broadcast();
        new Drops(owner);
    }
}
