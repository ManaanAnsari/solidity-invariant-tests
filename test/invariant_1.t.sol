// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

// open testing : randomly calls all public functions
contract WETHOpenInvariantTesting is Test {
    WETH public weth;

    function setUp() public {
        weth = new WETH();
        targetContract(address(weth));
    }

    receive() external payable {}

    // calls = runs x depth , (runs, calls, reverts)
    // results (runs: 256, calls: 3840, reverts: 2309)
    function invariant_totalSupply_is_always_zero() public {
        assertEq(weth.totalSupply(), 0);
    }
}
