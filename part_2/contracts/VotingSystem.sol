// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VotingSystem is Ownable {
    string[] public candidates; // Array to store candidate names
    mapping(address => bool) public voters; // Mapping to track whether an address has voted
    mapping(uint256 => uint256) public votesReceived; // Mapping to store vote count for each candidate

    event Voted(address indexed voter, uint256 candidateIndex);

    constructor(string[] memory _candidates) {
        require(_candidates.length > 0, "At least one candidate required");
        candidates = _candidates;
    }

    // Function to allow a voter to cast their vote for a candidate
    function vote(uint256 candidateIndex) external {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!voters[msg.sender], "You have already voted");
        
        voters[msg.sender] = true;
        votesReceived[candidateIndex]++;
        
        emit Voted(msg.sender, candidateIndex);
    }

    // Function to get the total number of votes received by a specific candidate
    function getTotalVotes(uint256 candidateIndex) external view returns (uint256) {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        return votesReceived[candidateIndex];
    }

    // Function to check if a specific address has already voted
    function hasVoted(address voter) external view returns (bool) {
        return voters[voter];
    }

    // Function to add a new candidate (onlyOwner modifier)
    function addCandidate(string memory candidateName) external onlyOwner {
        candidates.push(candidateName);
    }

    // Function to remove a candidate (onlyOwner modifier)
    function removeCandidate(uint256 candidateIndex) external onlyOwner {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(votesReceived[candidateIndex] == 0, "Cannot remove a candidate with votes");
        
        for (uint256 i = candidateIndex; i < candidates.length - 1; i++) {
            candidates[i] = candidates[i + 1];
        }
        candidates.pop();
    }

    // Function to get the total number of candidates
    function getTotalCandidates() external view returns (uint256) {
        return candidates.length;
    }
}
