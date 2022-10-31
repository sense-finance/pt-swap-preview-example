// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

interface SpaceLike {
    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    struct SwapRequest {
        SwapKind kind;
        ERC20 tokenIn;
        ERC20 tokenOut;
        uint256 amount;
        // Misc data
        bytes32 poolId;
        uint256 lastChangeBlock;
        address from;
        address to;
        bytes userData;
    }

    function onSwap(
        SwapRequest memory swapRequest,
        uint256 currentBalanceTokenIn,
        uint256 currentBalanceTokenOut
    ) external view returns (uint256);
}

interface SpaceFactoryLike {
    function pools(address, uint256) external view returns (SpaceLike);
}

interface PeripheryLike {
    function spaceFactory() external view returns (SpaceFactoryLike);
}

interface AdapterLike {
    function target() external view returns (address);
    function ifee() external view returns (uint256);
    function scale() external returns (uint256);
    function scaleStored() external view returns (uint256);
}

contract SwapPreview {
    function previewUnderlyingIn(address adapter, uint256 maturity, uint256 amount) public returns (uint256) {
        SpaceLike space = SpaceFactoryLike(AddressBook.SPACE_FACTORY_1_3_0).pools(adapter, maturity);
        // adapter.scale()
        // vault.getPoolTokens()
        // pool.onSwap
        // return ptsOut;
    }

}

library AddressBook {
    address public constant DIVIDER_1_3_0 = 0x86bA3E96Be68563E41c2f5769F1AF9fAf758e6E0;
    address public constant PERIPHERY_1_3_0 = 0xFff11417a58781D3C72083CB45EF54d79Cd02437;
    address public constant SPACE_FACTORY_1_3_0 = 0x5f6e8e9C888760856e22057CBc81dD9e0494aA34;
    address public constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
}