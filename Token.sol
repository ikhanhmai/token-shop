//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Token____ is ERC20{
    
    constructor(string memory name, string memory symbol, uint initialSupply) public ERC20(name, symbol){
        _mint(msg.sender, initialSupply*1000000000000000000);
    }
    
}