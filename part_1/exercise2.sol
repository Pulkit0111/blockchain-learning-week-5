// SPDX-License-Identifier: MIT

/*
The provided smart contract has several issues, including a reentrancy vulnerability,
as well as unnecessary functions that manipulate balances directly. Additionally, 
the destroyContract function allows anyone to destroy the contract, which may not be 
desirable. Here's the corrected contract:
*/

pragma solidity ^0.8.0;

contract Exercise_2 {
    mapping(address => uint256) public balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function destroyContract() public onlyOwner {
        selfdestruct(payable(owner));
    }
}


/*
Changes:
- Removed unnecessary addBalances and subtractBalances functions since 
  they are not required.

- Added an onlyOwner modifier to restrict the destroyContract function 
  to the contract owner.

- Updated the deposit function to accept Ether and adjust the sender's 
  balance accordingly.

- Added a getContractBalance function to check the contract's balance.

- Modified the withdraw function to first deduct the balance and then perform 
  the transfer to prevent reentrancy attacks.
*/