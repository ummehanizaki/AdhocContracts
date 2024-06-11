// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract USDC is
    ERC20("USDC", "USDC"),
    ERC20Permit("Token"),
    AccessControl
{
    bool allowMinting;

    constructor() {
        uint256 INITIAL_SUPPLY = 1000 * 10 ** 6 * 10 ** decimals();
        allowMinting = true;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    function mint(uint256 amount) external {
        if (allowMinting == true) {
            _mint(msg.sender, amount);
        }   
    }

    function toggleMinting(
        bool _allowMinting
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        allowMinting = _allowMinting;
    }

}
