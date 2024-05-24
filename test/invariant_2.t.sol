// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

// handler based testing
// its like creating a scenarios
// and then running the tests (testing functions in a spesific conditions)

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    WETH public weth;
    uint256 public totalSupply;
    uint256 public numCalls;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function deposit(uint256 _amount) public {
        _amount = bound(_amount, 0, address(this).balance);
        weth.deposit{value: _amount}();
        totalSupply += _amount;
    }

    function withdraw(uint256 _amount) public {
        _amount = bound(_amount, 0, address(weth).balance);
        weth.withdraw(_amount);
        totalSupply -= _amount;
    }

    function fail() public {
        require(false, "fail");
    }
}

// note : Remember Handler is a common contract not a test contract
// so we need to create a test contract to test the handler

contract WETHHandlerTest is Test {
    WETH weth;
    Handler handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);
        deal(address(handler), 100 ether);
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = handler.deposit.selector;
        selectors[1] = handler.withdraw.selector;
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_eth_balance_1() public {
        assertEq(address(weth).balance, handler.totalSupply());
        // console.log("handler numCalls", handler.numCalls());
    }
}
