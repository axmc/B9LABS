pragma solidity ^0.4.6;
//Minimal contract functions - file version Splitter706-1
// per Rob comments

contract Splitter{
    
    address public owner;
  
    

    
    mapping (address => uint) public userBalances;
    
    event LogFundsSplit(string _msg);
    
    function Splitter() public{
      owner= msg.sender;
  }
    
 
    
 function splitFunds(address recipient1, address recipient2) public payable returns (bool success){
        
      uint amount = msg.value/2;
            userBalances[recipient1]  += amount;
            userBalances[recipient2]  += amount; 
              return true;
           
         LogFundsSplit("funds have been split");
    }
    
    
    function showContractTotal() public returns (uint totalAmount) {
         
            totalAmount =this.balance;
    return  totalAmount;
        }
        
    function userBalances(address index) public constant returns (uint balanceAtAddress)  {
            return userBalances[index];
    
        }
        
        function simpleUserBalance(address directindex)public constant returns (uint balanceAtSimpleAddress){
            balanceAtSimpleAddress = directindex.balance;
            return balanceAtSimpleAddress;
        }

}
    
    
    
    
    
    
    

