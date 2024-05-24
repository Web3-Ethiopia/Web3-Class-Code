// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import  {LendingAndBorrowing} from "../src/LendingAndBorrowing.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract LendingAndBorrowingTest is Test {
  LendingAndBorrowing public lendingAndBorrowing;

  function setUp() public {
    address cometProxy = address(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e); // Replace with mock Comet proxy address
    address rewardsAddr = address(0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD); // Replace with mock rewards address
    // address delegateCallHandler = address(0); // Replace with mock delegate call handler address
    lendingAndBorrowing = new LendingAndBorrowing(cometProxy, rewardsAddr);
  }

  // Invariant test for user's total supplied being greater than or equal to total borrowed
  function testTotalSuppliedGreaterThanBorrowed() public {
    // Arrange
    address user = address(this); // Test contract as the user
    uint256 supplyAmount = 10e21;



    deal(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531,address(user), 10e25);
    IERC20(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531).approve(address(lendingAndBorrowing), 10e23);

    // Act
    lendingAndBorrowing.supplyCollateral(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531, supplyAmount); // Replace with actual token address

    // Assert
    uint totalSupplied = lendingAndBorrowing.getTotalSuppliedAmount(user);

    uint256 totalBorrowed = lendingAndBorrowing.getTotalBorrowedAmount(user);
    assert(totalSupplied >= totalBorrowed);
  }

  // Additional invariant tests can be written here
  // You can test other invariants like:
  // - User's supplied allocation percentages add up to 100%
  // - User's share reflects their contribution to the pool (consider specific pool logic)
  // ... (add more tests based on your contract logic)
}
