// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

contract WETHFuzzTesting is Test {
    WETH public weth;

    function setUp() public {
        weth = new WETH();
        deal(address(this), 100 ether);
    }

    receive() external payable {}

    function test_deposit(uint256 amount) public {
        vm.assume(amount < 100 ether && amount > 0);
        weth.deposit{value: amount}();
        assertEq(weth.balanceOf(address(this)), amount);
    }
}
