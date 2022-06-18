// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Hyperfy.sol";

contract HyperfyTest is Test {

    Hyperfy public hyperfy;

    address owner;
    address msgSender;
    address hyperfyAddr;
    address payable _hyperfyAddr;

    address[] internal airdropList;

    //prank makes hyperfy's owner == msg.sender, which is the default account

    function setUp() public {
        owner = msg.sender;
        vm.prank(owner);
        hyperfy = new Hyperfy();
        hyperfyAddr = address(hyperfy);
        _hyperfyAddr = payable(hyperfyAddr);
    }

    function testEncodeId() public {
        uint256 id = hyperfy.encodeId(1, 2);
        console.log(id);
    }

    function testDecodeId() public {
        uint256 id;
        id = hyperfy.encodeId(1, 2);
        (uint256 dropId, uint256 uniqueId) = hyperfy.decodeId(id);
        console.log(dropId, uniqueId);
    }


}