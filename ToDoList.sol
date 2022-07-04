// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ToDoList {

    struct Todos {
        string task;
        bool done;
    }

    address writer;

    mapping (address => Todos[]) public personList;

    function addToList(string memory _task) public {
        Todos memory list = Todos(_task, false);
        personList[msg.sender].push(list);
        writer = msg.sender;
    }

    function checkTask(uint _id) public {
        if(msg.sender == writer) {
           personList[msg.sender][_id].done = true;
        } else {
            revert("Not Authorized");
        }
    }

    function removeTask(uint _id) public {
        if(msg.sender == writer) {
            delete personList[msg.sender][_id];
        } else {
            revert("Not Authorized");
        }
        
    }

    function editTask(string memory _task, uint _id) public {
        if(msg.sender == writer) { 
            personList[msg.sender][_id].task = _task;
        } else {
            revert("Not Authorized");
        }
    }

}