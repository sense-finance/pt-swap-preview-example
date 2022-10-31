// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";
import { FixedPointMathLib } from "solmate/utils/FixedPointMathLib.sol";

interface SpaceLike {
    struct SwapRequest {
        BalancerVaultLike.SwapKind kind;
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

    function getPoolId() external view returns (bytes32);
    function pti() external view returns (uint256);
}

interface BalancerVaultLike {
    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    function getPoolTokens(bytes32 poolId)
        external
        view
        returns (
            ERC20[] memory tokens,
            uint256[] memory balances,
            uint256 maxBlockNumber
        );
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
    using FixedPointMathLib for uint256;

    function previewUnderlyingIn(address adapter, uint256 maturity, uint256 amountUnderlying) public returns (uint256 ptsOut) {
        SpaceLike space = AddressBook.SPACE_FACTORY_1_3_0.pools(adapter, maturity);
        uint256 scale = AdapterLike(adapter).scale();
        bytes32 poolId = space.getPoolId();
        uint256 pti = space.pti();

        (ERC20[] memory tokens, uint256[] memory balances, ) = AddressBook.BALANCER_VAULT.getPoolTokens(poolId);

        uint256 amountTarget = amountUnderlying.divWadDown(scale);

        ptsOut = space.onSwap(
            SpaceLike.SwapRequest({
                kind: BalancerVaultLike.SwapKind.GIVEN_IN,
                tokenIn: tokens[1 - pti],
                tokenOut: tokens[pti],
                amount: amountTarget,
                poolId: poolId,
                // The following are unused for previews
                lastChangeBlock: 0,
                from: address(0),
                to: address(0),
                userData: ""
            }),
            balances[1 - pti],
            balances[pti]
        );
    }

}

library AddressBook {
    address public constant DIVIDER_1_3_0 = 0x86bA3E96Be68563E41c2f5769F1AF9fAf758e6E0;
    address public constant PERIPHERY_1_3_0 = 0xFff11417a58781D3C72083CB45EF54d79Cd02437;
    SpaceFactoryLike public constant SPACE_FACTORY_1_3_0 = SpaceFactoryLike(0x5f6e8e9C888760856e22057CBc81dD9e0494aA34);
    BalancerVaultLike public constant BALANCER_VAULT = BalancerVaultLike(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
}