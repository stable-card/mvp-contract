// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title PolicyContract
 * @dev Manages user benefit policies by storing a hash of the policy data.
 * This approach saves gas by keeping the full policy data off-chain.
 */
contract PolicyContract {
    address public backendServer;
    mapping(address => bytes32) public userPolicyHashes;

    event PolicySet(address indexed user, bytes32 indexed policyHash);

    /**
     * @dev Throws if called by any account other than the backend server.
     */
    modifier onlyBackendServer() {
        require(msg.sender == backendServer, "Caller is not the backend server");
        _;
    }

    /**
     * @dev Sets the contract deployer as the initial backend server address.
     * The backend server address can be updated later by the current backend server.
     */
    constructor() {
        backendServer = msg.sender;
    }

    /**
     * @notice Sets or updates the policy hash for a user.
     * @dev Can only be called by the backend server.
     * @param _user The address of the user.
     * @param _policyHash The keccak256 hash of the user's policy JSON.
     */
    function setPolicy(address _user, bytes32 _policyHash) external onlyBackendServer {
        require(_user != address(0), "User address cannot be zero");
        userPolicyHashes[_user] = _policyHash;
        emit PolicySet(_user, _policyHash);
    }

    /**
     * @notice Retrieves the policy hash for a given user.
     * @param _user The address of the user.
     * @return bytes32 The policy hash of the user.
     */
    function getPolicyHash(address _user) external view returns (bytes32) {
        return userPolicyHashes[_user];
    }

    /**
     * @notice Updates the backend server address.
     * @dev Can only be called by the current backend server.
     * @param _newBackendServer The address of the new backend server.
     */
    function updateBackendServer(address _newBackendServer) external onlyBackendServer {
        require(_newBackendServer != address(0), "New backend server address cannot be zero");
        backendServer = _newBackendServer;
    }
}
