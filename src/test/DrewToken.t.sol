pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "./CheatCodes.sol";
import "../DrewToken.sol";

contract DrewTokenTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    DrewToken token;
    address owner;
    address recipient;
    address spender;

    uint256 initialSupply = 1000 ether;
    uint256 transferAmount = 100 ether;
    uint256 approvalAmount = 50 ether;

    function setUp() public {
        owner = address(this);
        recipient = address(
            uint160(uint(keccak256(abi.encodePacked("recipient"))))
        );
        spender = address(
            uint160(uint(keccak256(abi.encodePacked("spender"))))
        );
        token = new DrewToken("DrewToken", "DRU", initialSupply);
    }

    function testGenerateNewTokens() public {
        assertEq(
            token.totalSupply(),
            initialSupply,
            "Total supply should be 1000"
        );
        assertEq(
            token.balanceOf(owner),
            initialSupply,
            "Owner balance should be 1000"
        );
    }

    function testTransferTokens() public {
        token.transfer(recipient, transferAmount);
        assertEq(
            token.balanceOf(owner),
            initialSupply - transferAmount,
            "Owner balance should be 900 after transfer"
        );
        assertEq(
            token.balanceOf(recipient),
            transferAmount,
            "Recipient balance should be 100 after transfer"
        );
    }

    function testCheckBalanceOfTokens() public {
        assertEq(
            token.balanceOf(owner),
            initialSupply,
            "Owner balance should be 1000"
        );
    }

    function testApproveThirdPartyToSpendTokens() public {
        token.approve(spender, approvalAmount);
        assertEq(
            token.allowance(owner, spender),
            approvalAmount,
            "Allowance should be 50 after approval"
        );
    }

    function testTransferFromApprovedThirdParty() public {
        token.approve(spender, approvalAmount);

        cheats.prank(spender);

        token.transferFrom(owner, recipient, approvalAmount);

        assertEq(
            token.balanceOf(owner),
            initialSupply - approvalAmount,
            "Owner balance should be 950 after transfer"
        );
        assertEq(
            token.balanceOf(recipient),
            approvalAmount,
            "Recipient balance should be 50 after transfer"
        );
        assertEq(
            token.allowance(owner, spender),
            0,
            "Allowance should be 0 after transfer"
        );
    }
}
