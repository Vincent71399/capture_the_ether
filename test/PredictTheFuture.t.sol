// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PredictTheFuture} from "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        predictTheFuture = new PredictTheFuture{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function calculate_answer() private view returns(uint8 answer) {
        answer = uint8(
            uint256(
                keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
            )
        ) %10;
    }

    function test_solution() public {
        uint256 settleBlock = block.number + 1;
        uint256 startTimestamp = block.timestamp;
        predictTheFuture.lockInGuess{value: 1 ether}(0);
        vm.roll(settleBlock + 2);
        uint256 timestamp = startTimestamp + 1;
        vm.warp(timestamp);

        while(calculate_answer() != 0){
            timestamp ++;
            vm.warp(timestamp);
//            console.log(calculate_answer());
        }
        predictTheFuture.settle();
        assertEq(predictTheFuture.isComplete(), true);
    }
}
