//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SampleAccount {

mapping(address=>uint) private addressToAmountMapping; 
bool private isAccountExist;
address private constant  ACCOUNT = 0xbDA5747bFD65F08deb54cb465eB87D40e51B197E;

// openAccount converts the _minimumOpeningAmount in ether amount and validates that the minimum amount to open account
// is maintained. It checks whether the account exist or not, if it does not exist, then it opens the account with 
// _minimumOpeningAmount and returns the account address.

function openAccount(uint _openingAmount) private returns(address) {

    uint _minimumOpeningAmountInEther = 500 * 10**18;
    uint _openingAmountInEther = _openingAmount * 10**18;
    assert(_openingAmountInEther >= _minimumOpeningAmountInEther);
    addressToAmountMapping[ACCOUNT] += _openingAmountInEther;
    isAccountExist = true;
    console.log("Account %s opened with %s amount.",ACCOUNT,_openingAmountInEther);
    return ACCOUNT;
}

// getAccount opens the account for _minimumOpeningAmount and returns the account address. 

function getAccount(uint _openingAmount) public  returns(address){
    return openAccount(_openingAmount);
}

// withdrawFromAccount allows withdrawal from the account for the supplied account address and the amount to withdraw from account.
// It allows the withdrawal only when the account balance is greater than withdrawal amount, and withdrawal does not allow
// account balance to fall below the minimum account balance requirement.

function withdrawFromAccount(address _account,uint _amountToWithdraw) public  {

    uint minimumAmountToKeepInAccountInEther = 50 * 10**18;
    uint _amountToWithdrawInEther = _amountToWithdraw * 10**18;
    uint amountInAccount = addressToAmountMapping[_account];
    console.log("Amount in account %s : %s",_account,amountInAccount);
    assert(amountInAccount > 0);
    require(amountInAccount > _amountToWithdrawInEther,"Insufficient balance!");
    addressToAmountMapping[_account] -= _amountToWithdrawInEther;
    if(addressToAmountMapping[_account] < minimumAmountToKeepInAccountInEther){
        console.log("Account %s has balance %s which is below the required minimum balance %s",_account,addressToAmountMapping[_account],minimumAmountToKeepInAccountInEther);
        revert("Account balance is below the required minimum balance.");
    }
}

// accountBalance returns the account balance only if the account exists.

function accountBalance(address _account) public view returns(uint){

    require(isAccountExist,"Account not found!");
    console.log("Account %s has balance %s",_account,addressToAmountMapping[_account]);
    return addressToAmountMapping[_account];

}

}