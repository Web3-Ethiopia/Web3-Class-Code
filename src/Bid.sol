// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BID {
    IERC20 public WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address private contractAddress;
    address[5] private bidders;
    mapping(address => uint256 bidAmount) bidMap;

    constructor(address _contractAddress) {
        contractAddress = _contractAddress;
    }

    function approveBid(uint256 _amount) public {
        require(WETH.balanceOf(msg.sender) >= _amount, "Insufficent funds");
        require(_amount > bidMap[bidders[0]], "Insufficent bid value");

        // 1,3,5,7,9
        for (uint8 i = 0; i < bidders.length; i++) {
            if (_amount > bidMap[bidders[i]]) {
                if (i != 0) {
                    bidders[i - 1] = bidders[i];
                }

                if (i == bidders.length - 1) {
                    bidMap[bidders[i]] = _amount;
                    bidders[i] = msg.sender;
                } else {
                    if (bidMap[bidders[i + 1]] >= _amount) {
                        bidMap[bidders[i]] = _amount;
                        bidders[i] = msg.sender;
                    }
                }
            }
        }

        WETH.approve(contractAddress, _amount);
    }
}