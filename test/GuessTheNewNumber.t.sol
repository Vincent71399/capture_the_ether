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

    function test_solution() public {
        uint8 answer = uint8(
            uint256(
                //can use vm.getBlockNumber() and vm.getBlockTimestamp() instead
                keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)
                )
            )
        );
        guessTheNewNumber.guess{value: 1 ether}(answer);
        assertEq(guessTheNewNumber.isComplete(), true);
    }
}
