# Real Estate Management Smart Contract

Solidity smart contracts for real estate asset management, allowing the contract owner to register and edit property reviews, and allowing users to purchase available properties

## Description

The RealEstateManager smart contract is designed to easily list, manage and sell real estate assets on the Ethereum blockchain. The contract allows the contract owner to list the property as residential or commercial with an associated valuation. Users can purchase these assets by sending an appropriate amount of ether, after which the assets are removed from the register. The agreement also provides the owner with the function to update the value of any listed property and includes mechanisms to ensure that the owner is the only one capable of carrying out administrative costs. Smart contracts provide a transparent, secure, and immutable record of real estate transactions.

## Getting Started

In this assessment, I have used remix IDE [https://remix.ethereum.org/]

### Executing program
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateManager {
    enum EstateType { Residential, Commercial }

    struct Estate {
        string identifier;
        EstateType estateType;
        uint256 valuation;
    }

    address public contractOwner;
    mapping(string => Estate) public estateRegistry;

    event EstateRegistered(string identifier, uint256 valuation);
    event EstateSold(string identifier, uint256 valuation);
    event ValuationUpdated(string identifier, uint256 newValuation);

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Action restricted to contract owner");
        _;
    }

    constructor() {
        contractOwner = msg.sender;
    }

    function registerEstate(string memory identifier, EstateType estateType, uint256 valuation) public onlyOwner {
        estateRegistry[identifier] = Estate(identifier, estateType, valuation);
        emit EstateRegistered(identifier, valuation);
    }

    function purchaseEstate(string memory identifier) public payable {
        Estate memory estate = estateRegistry[identifier];
        require(estate.valuation > 0, "Estate not available for purchase");
        require(msg.value >= estate.valuation, "Insufficient payment for estate");

        // Remove the estate from registry
        delete estateRegistry[identifier];

        emit EstateSold(identifier, estate.valuation);
    }

    function modifyValuation(string memory identifier, uint256 newValuation) public onlyOwner {
        Estate storage estate = estateRegistry[identifier];
        require(estate.valuation > 0, "Estate does not exist");

        estate.valuation = newValuation;
        emit ValuationUpdated(identifier, newValuation);
    }

    function estateExists(string memory identifier) public view returns (bool) {
        return estateRegistry[identifier].valuation > 0;
    }
}
```
To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.7" (or another compatible version), and then click on the Compile button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the  contract from the dropdown menu, and then click on the "Deploy" button.

## Authors

Pawan Kumar - (https://www.linkedin.com/in/pawan-pandey-540a94266/)


## License

This project is licensed under the MIT License
