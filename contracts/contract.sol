pragma solidity ^0.8.11;

contract Trada {
    string public name = "Tra Da";
    string public symbol = "ICETEA";
    uint256 public decimals = 8;
    uint256 totalSupply = 1000000000;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    struct Player {
        uint32 level;
        uint256 lastWorked;
    }

    mapping(address => Player) public players;
    mapping(address => uint256) public rewardOfPlayers;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(){
        emit Transfer(address(0x0), address(this), totalSupply);
        balances[address(this)] = totalSupply;
        balances[msg.sender] = 10000;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf(msg.sender) >= value, "Not enough balance.");
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(balanceOf(from) >= value, "balance too low");
        require(allowance[from][msg.sender] >= value, "allowance too low");
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function work() public returns(bool){
        if (players[msg.sender].level == 0){
            players[msg.sender] = Player(1,0);
        }

        uint256 time_now = block.timestamp;
        if (players[msg.sender].lastWorked < time_now) {
            uint256 reward = 680;
            rewardOfPlayers[msg.sender] += reward;
            players[msg.sender].lastWorked = time_now;
            return true;

        } else {
            return false;
        }
    }

    function claimReward() public returns (bool) {
        uint256 rewardOfUser = rewardOfPlayers[msg.sender];
        require(balanceOf(address(this)) >= rewardOfUser, "Khong du phan thuong de tra cho User");

        balances[address(this)] -= rewardOfUser;
        balances[msg.sender] += rewardOfUser;
        emit Transfer(address(this), msg.sender, rewardOfUser);

        rewardOfPlayers[msg.sender] = 0;

        return true;
    }

}