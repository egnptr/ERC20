// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";
import "./SafeMath.sol";

contract ERC20 is IERC20 {
  using SafeMath for uint256;

  mapping(address => uint256) private balances;

  mapping(address => mapping(address => uint256)) private allowed;

  uint256 private _totalSupply;

  string private _name;
  string private _symbol;

  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  function name() public view virtual override returns (string memory) {
    return _name;
  }

  function symbol() public view virtual override returns (string memory) {
    return _symbol;
  }

  function decimals() public view virtual override returns (uint8) {
    return 18;
  }

  function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address _owner)
    public
    view
    virtual
    override
    returns (uint256)
  {
    return balances[_owner];
  }

  function allowance(address _owner, address _spender)
    public
    view
    virtual
    override
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  function transfer(address _to, uint256 _value)
    public
    virtual
    override
    returns (bool)
  {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value)
    public
    virtual
    override
    returns (bool)
  {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public virtual override returns (bool) {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function increaseApproval(address _spender, uint256 _addedValue)
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue)
    );
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint256 _subtractedValue)
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function _mint(address _account, uint256 _amount) internal {
    require(_account != address(0), "IERC20: mint to the zero address");

    _totalSupply = _totalSupply.add(_amount);
    balances[_account] = balances[_account].add(_amount);
    emit Transfer(address(0), _account, _amount);
  }

  function _burn(address _account, uint256 _amount) internal {
    require(_account != address(0), "IERC20: burn from the zero address");
    require(_amount <= balances[_account]);

    _totalSupply = _totalSupply.sub(_amount);
    balances[_account] = balances[_account].sub(_amount);
    emit Transfer(_account, address(0), _amount);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    require(owner != address(0), "IERC20: approve from the zero address");
    require(spender != address(0), "IERC20: approve to the zero address");

    allowed[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(
    address from,
    address to,
    uint256 value
  ) private {
    require(from != address(0), "IERC20: transfer from the zero address");
    require(to != address(0), "IERC20: transfer to the zero address");

    balances[from] = balances[from].sub(value);
    balances[to] = balances[to].add(value);
    emit Transfer(from, to, value);
  }
}
