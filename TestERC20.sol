// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ERC20.sol";

contract TestToken is ERC20 {
  address public minter;

  event MinterChanged(address indexed from, address to);

  constructor(uint256 _totalSupply) payable ERC20("Gepi", "GEPI") {
    minter = msg.sender;
    _mint(msg.sender, _totalSupply);
  }

  function passMinterRole(address _minter) public returns (bool) {
    require(
      msg.sender == minter,
      "Error, only owner can change pass minter role"
    );
    minter = _minter;

    emit MinterChanged(msg.sender, _minter);
    return true;
  }

  function mint(address account, uint256 amount) public {
    require(
      msg.sender == minter,
      "Error, msg.sender does not have minter role"
    );
    _mint(account, amount);
  }

  function burn(uint256 amount) public virtual {
    _burn(msg.sender, amount);
  }

  function burnFrom(address account, uint256 amount) public virtual {
    uint256 currentAllowance = allowance(account, msg.sender);
    require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
    unchecked {
      _approve(account, msg.sender, currentAllowance - amount);
    }
    _burn(account, amount);
  }
}
