// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {BenefitRegistry} from "../src/BenefitRegistry.sol";
import {PolicyContract} from "../src/PolicyContract.sol";

contract Deploy is Script {
    function run() external returns (address, address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying BenefitRegistry...");
        BenefitRegistry benefitRegistry = new BenefitRegistry();
        console.log("BenefitRegistry deployed to:", address(benefitRegistry));

        console.log("Deploying PolicyContract...");
        PolicyContract policyContract = new PolicyContract();
        console.log("PolicyContract deployed to:", address(policyContract));

        vm.stopBroadcast();
        return (address(benefitRegistry), address(policyContract));
    }
}
