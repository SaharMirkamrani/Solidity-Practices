// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract HotelReservation {
    address public owner;

    event Book(address customer, uint value);

    constructor() {
        owner = msg.sender;
    }

    modifier costs(uint amount) {
        require(msg.value == amount, "Too high or too low deposited.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    struct Room {
        uint roomNumber;
        bool booked;
    }

    mapping(address => mapping(uint => Room)) public customerRooms;

    function book(uint _roomNumber) public payable costs(1 ether) {
        Room memory room;
        require(room.booked == false);
        (bool success, ) = address(this).call{value: msg.value}("");
        require(success == true);
        room.roomNumber = _roomNumber;
        room.booked = true;
        customerRooms[msg.sender][_roomNumber] = room;
        emit Book(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
