
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Swap {

    IERC20 public token1;
    IERC20 public token2;
    address public owner1;
    address public owner2;
    uint public amount1;
    uint public amount2;

    constructor(address _token1, address _token2, address _owner1, address _owner2, uint _amount1, uint _amount2) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        owner1 = _owner1;
        owner2 = _owner2;
        amount1 = _amount1;
        amount2 = _amount2;
    }


    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not Authorized");
        require(token1.allowance(owner1, address(this)) >= amount1, "Not allowed");
        require(token2.allowance(owner2, address(this)) >= amount2, "Not allowed");

        _safeTransfer(token1, owner1, owner2, amount1);
        _safeTransfer(token2, owner2, owner1, amount2);

    }

    function _safeTransfer(IERC20 token, address sender, address recipient, uint amount) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Transaction failed.");
    }


}