// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";

contract InvariantZero {
    bool public flag;

    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}

    function func_5() external {
        flag = true;
    }
}

contract InvariantZeroTest is Test {
    InvariantZero target;

    function setUp() public {
        target = new InvariantZero();
    }

    function invariant_flag_is_always_false() public {
        assertEq(target.flag(), false);
    }
}
