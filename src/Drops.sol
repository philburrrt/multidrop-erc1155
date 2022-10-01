// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

// Hyperfy App special needs
// [x] Add a setToken() function to enable HYPER sales in the future
// [x] Add the ability to specify HYPER price of a drop along with ETH
// [X] Add the ability to edit HYPER price of a drop
// [x] Add onlyCreator modifier
// [] Add onlyCreator to devMint()
// [x] only contract owner can modify a drop tokenUri after initiation
// [x] Assign an creator (user who sent createDrop() tx) to the drop
//  - [x] Creator can adjust drop details whenever they please, except for the tokenURI
//  - [] Creator can require a certain ERC20 or ERC721 token to be held by the buyer
//  - [] Creator can activate or deactivate the drop
// [] onlyCreator can collected owed funds
// [] add fees to mint
// [] owner of contract can collect fees
// [] Auto increment dropId
// [] Move activateSale() to editDrop()

contract Drops is ERC1155, Ownable {
    struct dropVariables {
        uint256 ethPrice;
        uint256 tokenPrice;
        uint256 maxSupply;
        uint256 supply;
        string tokenURI;
        address creator;
        address wlToken;
        bool saleIsActive;
        bool acceptToken;
    }

    modifier onlyCreator(uint256 id) {
        require(msg.sender == dropInfo[id].creator, "Only creator can do this");
        _;
    }

    IERC20 public paymentToken;
    uint256 public fee;

    mapping(uint256 => dropVariables) public dropInfo;
    mapping(address => uint256) public ethOwed;
    mapping(address => uint256) public tokenOwed;

    constructor(address _owner) ERC1155("") {
        transferOwnership(_owner);
    }

    function uri(uint256 id) public view override returns (string memory) {
        return (dropInfo[id].tokenURI);
    }

    function setPaymentToken(address _tokenAddr) public onlyOwner {
        paymentToken = IERC20(_tokenAddr);
    }

    function createDrop(
        uint256 id,
        uint256 ethPrice,
        uint256 tokenPrice,
        bool acceptToken,
        uint256 supplyAmt,
        address wlToken,
        string memory tokenURI
    ) public {
        require(dropInfo[id].maxSupply == 0, "Drop already exists");
        dropInfo[id].creator = msg.sender;
        dropInfo[id].acceptToken = acceptToken;
        dropInfo[id].tokenPrice = tokenPrice;
        dropInfo[id].ethPrice = ethPrice;
        dropInfo[id].maxSupply = supplyAmt;
        dropInfo[id].wlToken = wlToken;
        dropInfo[id].tokenURI = tokenURI;
    }

    function editDrop(
        uint256 id,
        uint256 ethPrice,
        uint256 tokenPrice,
        bool acceptToken,
        uint256 supplyAmt,
        address wlToken
    ) public onlyCreator(id) {
        require(dropInfo[id].maxSupply != 0, "Drop does not exist");
        require(dropInfo[id].supply <= supplyAmt, "Supply cannot be decreased");
        dropInfo[id].ethPrice = ethPrice;
        dropInfo[id].tokenPrice = tokenPrice;
        dropInfo[id].acceptToken = acceptToken;
        dropInfo[id].maxSupply = supplyAmt;
        dropInfo[id].wlToken = wlToken;
    }

    function editTokenURI(uint256 id, string memory tokenURI) public onlyOwner {
        require(dropInfo[id].maxSupply != 0, "Drop does not exist");
        dropInfo[id].tokenURI = tokenURI;
    }

    // transfer ownership of the drop to a new address
    function transferCreator(uint256 id, address newCreator)
        public
        onlyCreator(id)
    {
        dropInfo[id].creator = newCreator;
    }

    // basically airdrop for the creator's use
    function devMint(
        uint256 id,
        address[] calldata recipients,
        uint256[] calldata amount
    ) public onlyCreator(id) {
        for (uint256 i = 0; i < recipients.length; i++) {
            require(amount[i] <= dropInfo[id].maxSupply, "Supply exceeded");
            _mint(recipients[i], id, amount[i], "");
            dropInfo[id].supply += amount[i];
        }
    }

    function mintDrop(uint256 id, uint256 amount) public payable {
        require(dropInfo[id].saleIsActive == true, "Sale is not active");
        require(dropInfo[id].maxSupply > 0, "Drop is not yet available");
        require(
            dropInfo[id].supply + amount <= dropInfo[id].maxSupply,
            "Sold out"
        );
        if (dropInfo[id].acceptToken == true && msg.value == 0) {
            // TEST: to make sure it doesn't still mint if the transfer fails
            paymentToken.transferFrom(
                msg.sender,
                address(this),
                dropInfo[id].tokenPrice * amount
            );
            _mint(msg.sender, id, amount, "");
            dropInfo[id].supply += amount;
            tokenOwed[dropInfo[id].creator] += dropInfo[id].tokenPrice * amount;
        } else {
            require(
                dropInfo[id].ethPrice * amount == msg.value,
                "Drop price is incorrect"
            );
            _mint(msg.sender, id, amount, "");
            dropInfo[id].supply += amount;
            ethOwed[dropInfo[id].creator] += dropInfo[id].ethPrice * amount;
        }
    }
}
