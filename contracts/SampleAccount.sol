//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SampleAccount {

mapping(address=>uint) private addressToAmountMapping; 
bool private isAccountExist;

function openAccount(address _account1,uint _openingAmount) public  {

    uint _openingAmountInEther = _openingAmount * 10**18;
    addressToAmountMapping[_account1] += _openingAmountInEther;
    isAccountExist = true;
    console.log("Account %s opened with %s amount.",_account1,_openingAmountInEther);

}

function withdrawFromAccount(address _account,uint _amountToWithdraw) public payable {

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

function accountBalance(address _account) public view returns(uint){

    assert(isAccountExist);
    console.log("Account %s has balance %s",_account,addressToAmountMapping[_account]);
    return addressToAmountMapping[_account];

}

}