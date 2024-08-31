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

