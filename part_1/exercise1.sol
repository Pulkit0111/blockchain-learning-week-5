// SPDX-License-Identifier: MIT

/*
The provided smart contract has a potential bug in the deposit function. 
It allows anyone to deposit any amount of tokens to any address, which could 
be exploited to manipulate the balances of other users. To fix this issue, 
I made sure that only the caller's balance is updated. 
Here's the corrected contract:
*/

pragma solidity ^0.8.0;

contract Exercise_1 {
    mapping(address => uint256) public balances;

    function deposit(uint256 amount) public {
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
    }
}
