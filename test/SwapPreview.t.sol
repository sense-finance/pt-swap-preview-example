// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SwapPreview.sol";

contract SwapPreviewTest is Test {
    SwapPreview public swapPreview;

    address public constant MA_DAI_ADAPTER = 0x9887e67AaB4388eA4cf173B010dF5c92B91f55B5;
    uint256 public constant MA_DAI_SERIES_1 = 1688169600;


    function setUp() public {
        swapPreview = new SwapPreview();
    }

    function testSwaUnderlyingInPreview() public {
        uint256 PREVIEW_AMT = 1.1e18; // 1.1 DAI

        emit log_named_decimal_uint("DAI in", PREVIEW_AMT, 18);

        uint256 ptsOut = swapPreview.previewUnderlyingIn(MA_DAI_ADAPTER, MA_DAI_SERIES_1, PREVIEW_AMT);

        emit log_named_decimal_uint("PTs out", ptsOut, 18);
    }
}
