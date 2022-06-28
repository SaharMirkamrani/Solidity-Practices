// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract VendingMachine {
    address public owner;

    event Create(string name, uint amount, uint price);
    event Sell(string name, uint amount, uint price);
    event Claim(uint id, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    modifier costs(uint price) {
        require(msg.value == price, "Too high or too low payment.");
        _;
    }

    struct Product {
        string name;
        uint amount;
        uint price;
        bool inStock;
    }

    struct CustomerGoods {
        uint id;
        uint amount;
    }

    mapping(uint => Product) public products;
    mapping(address => mapping(uint => CustomerGoods)) public customerBalance;

    function setProduct(
        uint _id,
        string memory _name,
        uint _amount,
        uint _price
    ) public onlyOwner {
        Product memory product = Product(_name, _amount, _price, true);
        products[_id] = product;
        emit Create(_name, _amount, _price);
    }

    function buy(uint _id, uint _amount) public payable {
        require(products[_id].inStock == true, "The product is not in stock.");
        require(
            msg.value == products[_id].price * _amount,
            "Too high or too low payment."
        );
        require(products[_id].amount > _amount, "Not enough in stock");
        // (bool success, ) = address(this).call{value: msg.value}("");
        // require(success == true, "Transaction failed.");
        products[_id].amount -= _amount;
        if (products[_id].amount == 0) {
            products[_id].inStock = false;
        }

        emit Sell(
            products[_id].name,
            products[_id].amount,
            products[_id].price
        );
        claim(_id, _amount);
    }

    function claim(uint _productId, uint _amount) private {
        customerBalance[msg.sender][_productId].id = _productId;
        customerBalance[msg.sender][_productId].amount += _amount;
        emit Claim(
            customerBalance[msg.sender][_productId].id,
            customerBalance[msg.sender][_productId].amount
        );
    }

    function getCustomerBalanceProducts(uint _productId)
        public
        view
        returns (uint, uint)
    {
        return (
            customerBalance[msg.sender][_productId].id,
            customerBalance[msg.sender][_productId].amount
        );
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external {}
}
