//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public admin;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    event VoteCasted(address voter, string candidate);

    constructor(string[] memory _candidateNames) {
        admin = msg.sender;
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0
            }));
            console.log("Candidate added:", _candidateNames[i]);
        }
    }

    function vote(uint256 _candidateIndex) external {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        hasVoted[msg.sender] = true;
        candidates[_candidateIndex].voteCount += 1;

        console.log("Vote casted by:", msg.sender);
        console.log("Candidate voted for:", candidates[_candidateIndex].name);
        console.log("Total votes for candidate:", candidates[_candidateIndex].voteCount);

        emit VoteCasted(msg.sender, candidates[_candidateIndex].name);
    }

    function getWinner() external view returns (string memory) {
        uint256 winningVoteCount = 0;
        uint256 winningCandidateIndex = 0;
        bool tie = false;
    
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateIndex = i;
                tie = false;
            } else if (candidates[i].voteCount == winningVoteCount) {
                tie = true;
            }
        }
        
        if (tie) {
            console.log("There is a tie.");
            return "There is a tie.";
        } else {
            console.log("Winning candidate:", candidates[winningCandidateIndex].name);
            console.log("Winning vote count:", winningVoteCount);
            return candidates[winningCandidateIndex].name;
        }
    }
}