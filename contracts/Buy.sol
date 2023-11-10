// SPDX-License-Identifier: MIT
// pragma solidity >=0.7.0;
pragma solidity >=0.5.5 <0.7.5;

import "@openzeppelin/contracts/GSN/GSNRecipient.sol";

contract Counterfeit {
    function buyProduct(bytes32 _secretId) external returns (bool) {}
}

contract Buy is GSNRecipient {
    event MainContractSet(address mainContractAddress);
    event OwnerChainged(address caller, address newOwner);
    event constructorSet(address owner);
    event productPurchased(address buyerAddress);

    address private owner;
    Counterfeit C;

    constructor() {
        owner = _msgSender();
        emit constructorSet(owner);
    }

    modifier onlyOwner() {
        require(_msgSender() == owner, "You can not set maincontract address");
        _;
    }

    function setMainContract(address _address) external onlyOwner {
        C = Counterfeit(_address);
        emit MainContractSet(_address);
    }

    function changeOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
        emit OwnerChainged(_msgSender(), _newOwner);
    }

    function buyProduct(uint256 _secretId) external {
        bytes32 hash = keccak256(abi.encodePacked(_secretId));
        C.buyProduct(hash);
        emit productPurchased(_msgSender());
    }

    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) override external view returns (uint256, bytes memory) {
        // all methods of this contract can be called with gas relay fuctionality....
        return (0, "");
    }

    function preRelayedCall(bytes calldata context) override public returns (bytes32) {
        return bytes32(uint256(123456));
    }

    function postRelayedCall(
        bytes calldata context,
        bool success,
        uint256 actualCharge,
        bytes32 preRetVal /*relayHubOnly*/
    ) override public {
        return;
    }

    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) override internal virtual{
        return;
    }

    function _preRelayedCall(bytes memory context) override internal virtual returns (bytes32) {
        return bytes32(uint256(123456));
    }
}
