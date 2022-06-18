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
    address mercuryAddr;
    address payable _mercuryAddr;

    address[] internal airdropList;

    address testAddr = 0xea414355A738D5715379Db885Db889049c20fc92;

    //prank makes mercury's owner == msg.sender, which is the default account

    function setUp() public {
        owner = msg.sender;
        vm.prank(owner);
        mercury = new M3rcury();
        mercuryAddr = address(mercury);
        _mercuryAddr = payable(mercuryAddr);
    }

    function testActivateSale() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        (uint256 price, uint256 maxSupply, uint256 supply, string memory tokenURI, bool saleIsActive) = mercury.dropInfo(0);
        assert(saleIsActive == true);
        vm.stopPrank();
    }

    function testDeactivateSale() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.deactivateSale(0);
        (uint256 price, uint256 maxSupply, uint256 supply, string memory tokenURI, bool saleIsActive) = mercury.dropInfo(0);
        assert(saleIsActive == false);
        vm.stopPrank();
    }

    function testFailMintNoActivation() public {
        vm.startPrank(owner);
        mercury.createDrop(0, 500e15, 10, "uri");
        vm.expectRevert();
        mercury.mint{value: 500e15}(0, 1);
        vm.stopPrank();
    }

    function testFailMintNoDrop() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        vm.expectRevert();
        mercury.mint{value: 500e15}(0, 1);
        vm.stopPrank();
    }

    function testFailMintOverSupply() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        vm.expectRevert();
        mercury.mint{value: 500e15 * 10}(0, 11);
        vm.stopPrank();
    }

    function testMint1Token() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.mint{value: 500e15}(0, 1);
        assert(mercury.balanceOf(owner, 0) == 1);
        vm.stopPrank();
    }

    function testMintMaxToken() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.mint{value: 500e15 * 10}(0, 10);
        assert(mercury.balanceOf(owner, 0) == 10);
        vm.stopPrank();
    }

    function testDevMint1Token() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.devMint(0, 1);
        assert(mercury.balanceOf(owner, 0) == 1);
        vm.stopPrank();
    }

    function testDevMintMaxToken() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.devMint(0, 10);
        assert(mercury.balanceOf(owner, 0) == 10);
        vm.stopPrank();
    }

    function testFailDevMintNoActivation() public {
        vm.startPrank(owner);
        mercury.createDrop(0, 500e15, 10, "uri");
        vm.expectRevert();
        mercury.devMint(0, 1);
        vm.stopPrank();
    }

    function testFailDevMintNoDrop() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        vm.expectRevert();
        mercury.devMint(0, 1);
        vm.stopPrank();
    }

    function testFailDevMintOverSupply() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        vm.expectRevert();
        mercury.devMint(0, 11);
        vm.stopPrank();
    }

    function testCreateDrop() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        (uint256 price, uint256 maxSupply, uint256 supply, string memory tokenURI, bool saleIsActive) = mercury.dropInfo(0);
        assert(price == 500e15);
        assert(maxSupply == 10);
        assert(supply == 0);
        assert(keccak256(abi.encodePacked(tokenURI)) == keccak256(abi.encodePacked("uri")));
        assert(saleIsActive == true);
        vm.stopPrank();
    }

    function testFailCreateDrop() public {
        vm.expectRevert();
        mercury.createDrop(0, 500e15, 10, "uri");
    }

    function testAirdrop1Address() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        airdropList.push(testAddr);
        mercury.airdrop(0, airdropList);
        assert(mercury.balanceOf(testAddr, 0) == 1);
        vm.stopPrank();
    }

    function testAirdrop10Address() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        airdropList.push(address(10));
        mercury.airdrop(0, airdropList);
        for(uint i = 0; i < airdropList.length; i++) {
            assert(mercury.balanceOf(airdropList[i], 0) == 1);
        }
        vm.stopPrank();
    }

    function testWithdrawal() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.mint{value: 500e15}(0, 1);
        mercury.withdraw();
        vm.stopPrank();
    }

    function testFailWithdrawal() public {
        vm.expectRevert();
        mercury.withdraw();
    }

    function testUserWithdrawal() public {
        vm.startPrank(owner);
        mercury.activateSale(0);
        mercury.createDrop(0, 500e15, 10, "uri");
        mercury.mint{value: 500e15}(0, 1);
        vm.stopPrank();
        uint256 startBalance = owner.balance;
        vm.startPrank(testAddr);
        mercury.withdraw();
        uint256 endBalance = owner.balance;
        assert(endBalance == startBalance + 500e15);
        vm.stopPrank();
    }

    function testFailUserWithdrawal() public {
        vm.startPrank(testAddr);
        vm.expectRevert();
        mercury.withdraw();
        vm.stopPrank();
    }

}