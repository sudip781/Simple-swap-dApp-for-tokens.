// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleSwap {
    address public owner;

    event Swap(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function swap(address tokenIn, address tokenOut, uint256 amountIn) external {
        require(amountIn > 0, "Invalid amount");

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = getSwapRate(tokenIn, tokenOut, amountIn);
        require(amountOut > 0, "Invalid output amount");

        IERC20(tokenOut).transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
    }

    function getSwapRate(address, address, uint256 amountIn) public pure returns (uint256) {
        return amountIn; // Placeholder, implement actual swap logic
    }

    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }
}
