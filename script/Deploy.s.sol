// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Drops} from "src/Drops.sol";

contract Deploy is Script {
    address owner = 0x000000000000000000000000000000000000dEaD; // your address here

    function setUp() public {}

    function run() public {
        vm.broadcast();
        new Drops(owner);
    }
}
