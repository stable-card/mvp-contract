// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title BenefitRegistry
 * @dev Manages the list of supported benefit categories.
 * Only the admin can add or remove categories.
 */
contract BenefitRegistry {
    address public admin;
    mapping(uint16 => bool) public supportedCategories;

    event CategoryAdded(uint16 indexed categoryCode);
    event CategoryRemoved(uint16 indexed categoryCode);

    /**
     * @dev Throws if called by any account other than the admin.
     */
    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    /**
     * @dev Sets the contract deployer as the admin.
     */
    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Adds a new benefit category.
     * @param _categoryCode The code for the new category.
     */
    function addCategory(uint16 _categoryCode) external onlyAdmin {
        require(!supportedCategories[_categoryCode], "Category already exists");
        supportedCategories[_categoryCode] = true;
        emit CategoryAdded(_categoryCode);
    }

    /**
     * @notice Removes an existing benefit category.
     * @param _categoryCode The code for the category to remove.
     */
    function removeCategory(uint16 _categoryCode) external onlyAdmin {
        require(supportedCategories[_categoryCode], "Category does not exist");
        supportedCategories[_categoryCode] = false;
        emit CategoryRemoved(_categoryCode);
    }

    /**
     * @notice Checks if a category is supported.
     * @param _categoryCode The category code to check.
     * @return bool True if the category is supported, false otherwise.
     */
    function isSupported(uint16 _categoryCode) external view returns (bool) {
        return supportedCategories[_categoryCode];
    }
}
