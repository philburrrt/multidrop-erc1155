// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Drops is ERC1155, Ownable {
    struct dropVariables {
        uint256 price;
        uint256 maxSupply;
        uint256 supply;
        string tokenURI;
        bool saleIsActive;
    }

    address payable _owner;

    mapping(uint256 => dropVariables) public dropInfo;

    constructor() ERC1155("") {
        _owner = payable(msg.sender);
    }

    function uri(uint256 id) public view override returns (string memory) {
        return (dropInfo[id].tokenURI);
    }

    function contractURI() public pure returns (string memory) {
        return
            "https://cdn.jsdelivr.net/gh/philburrrt/M3rcury/metadata/storefront";
    }

    function activateSale(uint256 id) public onlyOwner {
        dropInfo[id].saleIsActive = true;
    }

    function deactivateSale(uint256 id) public onlyOwner {
        dropInfo[id].saleIsActive = false;
    }

    function createDrop(
        uint256 id,
        uint256 price,
        uint256 supplyAmt,
        string memory tokenURI
    ) public onlyOwner {
        require(dropInfo[id].maxSupply == 0, "Drop already exists"); // if you set max supply, there's no turning back because the token can be minted at that point
        dropInfo[id].price = price;
        dropInfo[id].maxSupply = supplyAmt;
        dropInfo[id].tokenURI = tokenURI;
    }

    function devMint(uint256 id, uint256 amount) public onlyOwner {
        require(dropInfo[id].maxSupply > 0, "Drop is not available");
        require(
            dropInfo[id].supply + amount <= dropInfo[id].maxSupply,
            "Sold out"
        );

        _mint(msg.sender, id, amount, "");
        dropInfo[id].supply += amount;
    }

    function airdrop(uint256 id, address[] calldata recipients)
        external
        onlyOwner
    {
        require(dropInfo[id].maxSupply > 0, "Drop is not available");
        require(
            dropInfo[id].supply + recipients.length <= dropInfo[id].maxSupply,
            "Would exceed max supply"
        );
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], id, 1, "");
            dropInfo[id].supply += 1;
        }
    }

    function mint(uint256 id, uint256 amount) public payable {
        require(dropInfo[id].saleIsActive == true, "Sale is not active");
        require(dropInfo[id].maxSupply > 0, "Drop is not yet available");
        require(
            dropInfo[id].supply + amount <= dropInfo[id].maxSupply,
            "Sold out"
        );
        require(
            msg.value / amount == dropInfo[id].price,
            "Drop price is incorrect"
        );

        _mint(msg.sender, id, amount, "");
        dropInfo[id].supply += amount;
    }

    function withdraw() public {
        require(address(this).balance >= 0, "No ether");
        _owner.transfer(address(this).balance);
    }
}
