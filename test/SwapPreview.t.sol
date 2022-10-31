// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SwapPreview.sol";

contract SwapPreviewTest is Test {
    SwapPreview public swapPreview;

    function setUp() public {
        swapPreview = new SwapPreview();
    }

    // function testIncrement() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }
}
