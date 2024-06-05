// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheSecretNumber} from "../src/GuessTheSecretNumber.sol";

contract GuessTheSecretNumberTest is Test {
    GuessTheSecretNumber public guessTheSecretNumber;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        guessTheSecretNumber = new GuessTheSecretNumber{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function test_solution() public {
        bytes32 answerHash = vm.load(
            address(guessTheSecretNumber),
            bytes32(0)
        );
//        console.logBytes32(answerHash);
        uint8 answer;
        for (uint8 i = 0; i < 256; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                answer = i;
                break;
            }
        }
//        console.log(answer);
        guessTheSecretNumber.guess{value: 1 ether}(answer);
        assertEq(guessTheSecretNumber.isComplete(), true);
    }
}