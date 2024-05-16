// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../compoundContracts/CometInterface.sol";
import "../compoundContracts/CometRewards.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {console} from "forge-std/Test.sol";

contract DelegateCallHandler {
    CometInterface public comet;
    CometRewards public rewards;

    constructor(address _cometProxy, address _rewardsAddress) {
        comet = CometInterface(_cometProxy);
        rewards = CometRewards(_rewardsAddress);
    }

    function accrueAccount(address account) external {
        comet.accrueAccount(account);
    }

    function supply(address _asset, uint256 amount) external {
        console.log("CallWorking");
        comet.supply(_asset, amount);
    }

    function withraw(address _asset, uint256 amount) external {
        comet.withdraw(_asset, amount);
    }

    function getRewardOwed(address cometAddress, address account) external returns (CometRewards.RewardOwed memory) {
        return rewards.getRewardOwed(cometAddress, account);
    }
}
