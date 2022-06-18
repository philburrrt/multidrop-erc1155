// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract Hyperfy is ERC1155, Ownable {

    address payable _owner;
    uint256 max = 100000000;

    constructor() ERC1155("") {
        _owner = payable(msg.sender);
    }

    function encodeId(uint256 dropId, uint256 uniqueId) public view returns (uint256) {
        return (dropId * max) + uniqueId;
    }

    function decodeId(uint256 id) public view returns (uint256, uint256) {
        return ((id / max), (id % max));
    }

}