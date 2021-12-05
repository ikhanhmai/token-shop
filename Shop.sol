//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract AIOnebox{
    
    IERC20 private token_AOB;
    address private owner;
    uint public buy_ratio_AOB=10000;  // 1 eth = 10.000 AOB
    uint public sell_ratio_AOB=12000;  // 1 eth = 12.000 AOB
    uint public minimum_buy_AOB=1000000000000000;  // 0.001 ETH
    uint public minimum_sell_AOB=100*1000000000000000000; // 100 AOB
    bool public buy_active = true; // true: khach hang co the buy ABO cua Onebox
    bool public sell_active = false; // true: khach hang co the sell ABO cho Onebox
    
    constructor(address token_address){
        owner = msg.sender;
        token_AOB = IERC20(token_address);
    }
    
    modifier checkMaster(){
        require(msg.sender == owner, "You are not allowed to process.");
        _;
    }
    
    function buy_AOB() public payable{
        require(buy_active==true, "[001] AOB is not for sell right this time.");
        require(msg.value>=minimum_buy_AOB, "[002] You can not buy less 10 ODB (0.001 eth)"); 
        require(msg.value*buy_ratio_AOB<= token_AOB.balanceOf(address(this)), "[003] We dont have enought AOB to sell right");
        token_AOB.transfer(msg.sender, msg.value*buy_ratio_AOB);
    }
    
    function sell_AOB(uint amount) public{
        require(amount>=minimum_sell_AOB, "[006]Luong AOB can ban phai > 100 token");
        require(token_AOB.allowance(msg.sender, address(this))>= amount, "[007] AIOneBox has not permission to transfer you AOB");
        require(token_AOB.balanceOf(msg.sender)>=amount, "[008] You dont have AOB enought to sell.");
        require(address(this).balance>amount/sell_ratio_AOB, "[009] Sorry, we dont have enought ETH to sell right this time");
        token_AOB.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount/sell_ratio_AOB);
    }
    
    function update_Buy_Ratio_AOB(uint newRatio) public checkMaster{
        require(newRatio>0, "[004] AOB buy ratio must bigger than 0");
        buy_ratio_AOB = newRatio;
    }
    
    function update_Sell_Ratio_AOB(uint newRatio) public checkMaster{
        require(newRatio>0, "[005] AOB sell ratio must bigger than 0");
        sell_ratio_AOB = newRatio;
    }
    
    function withdrawETH_All() public checkMaster{
        payable(owner).transfer(address(this).balance);
    }
    
    function withdrawETH(uint amount) public checkMaster{
        require(amount<=address(this).balance);
        payable(owner).transfer(address(this).balance);
    }
}