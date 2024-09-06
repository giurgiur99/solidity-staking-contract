// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is Ownable, ReentrancyGuard {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    struct Stake{
        uint256 amount;
        uint256 stakedAt;
        uint256 rewards;
    }

    mapping(address => Stake) public stakes;
    uint256 public totalStaked;
    uint256 public rewardRate;
    uint256 public constant REWARD_INTERVAL = 1 days;

    constructor(IERC20 _stakingToken, IERC20 _rewardToken, uint256 _initialRewardRate, address initialOwner) Ownable(initialOwner) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        rewardRate = _initialRewardRate;
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be grater than 0");
        updateRewards(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount +=amount;
        stakes[msg.sender].stakedAt = block.timestamp;

        totalStaked +=amount;
     }

     function withdraw(uint256 amount) external nonReentrant{
          require(amount > 0, "Amount must be grater than 0");
          require(stakes[msg.sender].amount >= amount , "Invalid withdrawl");

          stakes[msg.sender].amount -= amount;
          stakingToken.transfer(msg.sender, amount);
          totalStaked -= amount;
          adjustRewardRate();
     }

     function claimRewards() external nonReentrant {
        updateRewards(msg.sender);
        uint256 rewards = stakes[msg.sender].rewards;
        require(rewards > 0, "Rewards not available");

        stakes[msg.sender].rewards = 0;
        rewardToken.transfer(msg.sender, rewards);
    }

    function depositRewards(uint256 amount) external onlyOwner {
        require(amount > 0, "Invalid deposit ampunt");
        rewardToken.transferFrom(msg.sender, address(this), amount);
    }

    function updateRewards(address user) internal {
        if (stakes[user].amount > 0) {
            uint256 timeStaked = block.timestamp - stakes[user].stakedAt;
            uint256 newRewards = (stakes[user].amount * rewardRate * timeStaked) / REWARD_INTERVAL;
            stakes[user].rewards += newRewards;
            stakes[user].stakedAt = block.timestamp;
        }
    }

    function adjustRewardRate() internal {
        if (totalStaked < 1e18) {
            rewardRate = 100;  
        } else if (totalStaked < 10e18) {
            rewardRate = 50;
        } else {
            rewardRate = 25;
        }
    }

    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
    }
}