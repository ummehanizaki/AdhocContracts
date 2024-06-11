// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ClientFreelanceEscrow is AccessControl {
    bytes32 public constant CLIENT_ROLE = keccak256("CLIENT_ROLE");
    bytes32 public constant FREELANCER_ROLE = keccak256("FREELANCER_ROLE");

    uint256 public constant SLASHING_PERCENTAGE = 100; // 1%

    address public client;
    address public freelancer;
    uint256 public amountToTransfer;
    uint256 public taskDuration;
    uint256 public startTimestamp;
    IERC20 public token;

    enum State { TASK_ASSIGNED, TASK_STARTED, TASK_COMPLETED, COMPLETION_APPROVED, DISPUTE_RAISED }
    State public currentState;

    constructor(address admin) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function initiate(
        address _client,
        address _freelancer,
        uint256 _amountToTransfer,
        uint256 _taskDuration,
        address _tokenAddress
    ) external onlyRole(CLIENT_ROLE) {
        client = _client;
        freelancer = _freelancer;
        amountToTransfer = _amountToTransfer;
        taskDuration = _taskDuration;
        token = IERC20(_tokenAddress);
        currentState = State.TASK_ASSIGNED;
        token.transferFrom(_client, address(this), _amountToTransfer);
    } 

    function changeStateForFreelance(State _state) external onlyRole(FREELANCER_ROLE) {
        require(_state == State.TASK_STARTED || _state == State.TASK_COMPLETED || _state == State.DISPUTE_RAISED, "Invalid state transition");
        if (_state == State.TASK_STARTED) {
            require(currentState == State.TASK_ASSIGNED, "Task not assigned");
            startTimestamp = block.timestamp;
            currentState = State.TASK_STARTED;
        } else if (_state == State.TASK_COMPLETED) {
            require(startTimestamp != 0, "Task not started");
            currentState = State.TASK_COMPLETED;
            uint256 delayDays = block.timestamp > (startTimestamp + taskDuration) ? (block.timestamp - (startTimestamp + taskDuration)) / 1 days : 0;
            uint256 penalty = (amountToTransfer * SLASHING_PERCENTAGE * delayDays) / 10000;
            amountToTransfer = amountToTransfer > penalty ? amountToTransfer - penalty : 0;
        } else if (_state == State.DISPUTE_RAISED) {
            require(currentState == State.TASK_COMPLETED, "Task not completed");
            currentState = State.DISPUTE_RAISED;
        }
    }

    function approveCompletion() external onlyRole(CLIENT_ROLE) {
        require(currentState == State.TASK_COMPLETED || currentState == State.DISPUTE_RAISED, "Invalid state for approval");
        currentState = State.COMPLETION_APPROVED;
        token.transfer(freelancer, amountToTransfer);
        token.transfer(client, token.balanceOf(address(this)));
    }

    function getState() external view returns (string memory) {
        if (currentState == State.TASK_ASSIGNED) {
            return "TASK_ASSIGNED";
        } else if (currentState == State.TASK_STARTED) {
            return "TASK_STARTED";
        } else if (currentState == State.TASK_COMPLETED) {
            return "TASK_COMPLETED";
        } else if (currentState == State.COMPLETION_APPROVED) {
            return "COMPLETION_APPROVED";
        } else if (currentState == State.DISPUTE_RAISED) {
            return "DISPUTE_RAISED";
        } else {
            return "UNKNOWN";
        }
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}

