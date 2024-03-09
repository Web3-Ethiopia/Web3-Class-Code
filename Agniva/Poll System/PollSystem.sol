// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/finance/VestingWallet.sol";
import "contracts/CoinVest.sol";

contract VotingSystem {
    // Struct for a Poll
    struct Poll {
        string question;
        string[] options;
        mapping(uint => uint) votes;
        bool exists;
    }
    // VestingWallet public vestingWallet;
    // State variables
    uint public nextPollId;
    mapping(uint => Poll) public polls;
    mapping(address => mapping(uint => bool)) public votes;
    mapping(address => address) public vestingWalletUsers; 
    enum Tier {goldTier, silverTier, bronzeTier}
    Tier public tiersGold=Tier.goldTier;
    Tier public tiersSilver=Tier.silverTier;
    Tier public tiersBronze=tiersBronze;
    WEB3ETH public TokenContract;
    string public ownerTier;


    constructor(address coinMintedto, address liquidityFees){
        TokenContract=new WEB3ETH(coinMintedto,liquidityFees);

    }

    // Event declaration
    event PollCreated(uint pollId, string question, string[] options);
    event Voted(uint pollId, uint option, address voter);
    event VestingEvent(address indexed walletCreator,address walletCreated);
    event TierChecked(address indexed ownerWallet, Tier);

    // Function to create a new poll
    function createPoll(string memory _question, string[] memory _options) public {
        require(_options.length >= 2, "There must be at least two options.");
        
        Poll storage p = polls[nextPollId];
        p.question = _question;
        p.options = _options;
        p.exists = true;

        emit PollCreated(nextPollId, _question, _options);
        nextPollId++;
    }

    function balanceCheck()public view returns(uint256){
        return TokenContract.balanceOf(msg.sender);
    }

    // function addVestingWallet(address walletAddress) public  {
    //     VestingWallet vestingWallet1=new VestingWallet(walletAddress,uint64(block.timestamp+30 days),365 days);
    //     vestingWalletUsers[walletAddress]=address(vestingWallet1);
    //     emit VestingEvent(walletAddress, vestingWalletUsers[walletAddress]);
    //     // require(vestingWalletUsers[walletAddress]!=0,"The wallet doesnt exist");
    
    // }

    function checkUserTier() public {
        uint256 balanceMock=TokenContract.balanceOf(msg.sender);
        
        if(balanceMock>100 && balanceMock<500){
        ownerTier="gold";
        emit TierChecked(msg.sender, tiersGold);
        } else if(balanceMock>500) {
            ownerTier="silver";
         emit TierChecked(msg.sender, tiersSilver);
        }else{
        ownerTier="tierBronze";
        emit TierChecked(msg.sender, tiersBronze);
        }
    }

    // Function to vote on a poll
    function vote(uint _pollId, uint _option) public {
        require(_pollId < nextPollId, "Poll does not exist.");
        require(!votes[msg.sender][_pollId], "You have already voted.");
        require(_option < polls[_pollId].options.length, "Invalid option.");


        polls[_pollId].votes[_option]++;
        votes[msg.sender][_pollId] = true;

        emit Voted(_pollId, _option, msg.sender);
    }

    // Function to get poll details
    function getPoll(uint _pollId) public view returns (string memory question, string[] memory options, uint[] memory _votes) {
        require(_pollId < nextPollId, "Poll does not exist.");

        Poll storage poll = polls[_pollId];
        uint[] memory voteCounts = new uint[](poll.options.length);

        for (uint i = 0; i < poll.options.length; i++) {
            voteCounts[i] = poll.votes[i];
        }
        // msg.sender _msgSender()
        return (poll.question, poll.options, voteCounts);
    }

}
