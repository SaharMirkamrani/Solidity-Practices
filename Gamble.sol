// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Gamble {

    address [] public peopleDeposited;
    uint public counter = 0;
    uint winNumber = 2;
    address public winner;

    function deposit() public payable {
        require(msg.value >= 10000 wei);
        counter++;
        peopleDeposited.push(msg.sender);
        if(counter == winNumber) {
            winner = msg.sender;
        }
    }

    function withdraw() public {
        if(winner == msg.sender) {
            payable(winner).transfer(address(this).balance);
        }
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    fallback() external {}
}