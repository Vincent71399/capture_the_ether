// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GuessTheRandomNumber} from "../src/GuessTheRandomNumber.sol";

contract GuessTheRandomNumberTest is Test {
    GuessTheRandomNumber public guessTheRandomNumber;
    address challenger;
    uint256 deploymentBlock;
    uint256 deploymentTimestamp;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        guessTheRandomNumber = new GuessTheRandomNumber{value: 1 ether}();
        deploymentBlock = block.number;
        deploymentTimestamp = block.timestamp;
        vm.startPrank(challenger);
    }

    function test_guess() public {
        uint8 answer = uint8(
            uint256(
                //can use vm.getBlockNumber() and vm.getBlockTimestamp() instead
                keccak256(abi.encodePacked(blockhash(deploymentBlock - 1), deploymentTimestamp)
                )
            )
        );
        guessTheRandomNumber.guess{value: 1 ether}(answer);
        assertEq(guessTheRandomNumber.isComplete(), true);
    }

    function test_guess_after_few_blocks() public {
        uint256 startBlock = block.number;

        // Advance the blockchain by one block
        vm.roll(startBlock + 10);

        uint8 answer = uint8(
            uint256(
            //can use vm.getBlockNumber() and vm.getBlockTimestamp() instead
                keccak256(abi.encodePacked(blockhash(deploymentBlock - 1), deploymentTimestamp)
                )
            )
        );
        guessTheRandomNumber.guess{value: 1 ether}(answer);
        assertEq(guessTheRandomNumber.isComplete(), true);
    }
}
