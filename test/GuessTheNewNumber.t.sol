// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheNewNumber} from "../src/GuessTheNewNumber.sol";

contract CounterTest is Test {
    GuessTheNewNumber public guessTheNewNumber;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        guessTheNewNumber = new GuessTheNewNumber{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function test_solution public {

    }
}
