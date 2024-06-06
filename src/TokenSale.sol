pragma solidity ^0.8.13;


contract TokenSale {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether; // 1e18

    constructor() payable {
        require(msg.value == 1 ether, "need 1 ether to deploy");
    }

    function isComplete() external view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) external payable {
        uint256 product;
        unchecked{
            product = numTokens * PRICE_PER_TOKEN;
        }

        require(msg.value == product, "math error");

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) external {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;

        //msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
        address payable toAddress=payable(msg.sender);
        toAddress.transfer(numTokens * PRICE_PER_TOKEN);
    }
}
