// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, stdStorage} from "forge-std/Test.sol";
import {GuessTheNumber} from "../src/GuessTheNumber.sol";

contract GuessTheNumberTest is Test {
    GuessTheNumber public guessTheNumber;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        guessTheNumber = new GuessTheNumber{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function test_solution() public {
        bytes32 slot0 = vm.load(
            address(guessTheNumber),
            bytes32(0)
        );
        uint8 guessValue = uint8(uint(slot0));
        guessTheNumber.guess{value: 1 ether}(guessValue);
        assertEq(guessTheNumber.isComplete(), true);
    }
}