// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {Drops} from "src/Drops.sol";

contract ContractScript is Script {
    address raAddr = 0xe27a2E0f987E96dDF845c3c1b110248eF8BdC629;
    address testAddr = 0x7789818791c12a2633e88d46457230bC1D9cd110;

    function setUp() public {}

    function run() public {
        vm.broadcast();
        new Drops(testAddr);
    }
}
