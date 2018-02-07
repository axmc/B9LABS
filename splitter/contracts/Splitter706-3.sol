pragma solidity ^0.4.19 ;
//Minimal contract functions 706-3
// Added dust collection
// added kill switch 

// tested in remix

contract Splitter{
    
    address public owner;
  
    

    
    mapping (address => uint) public userBalances;
    
    event LogFundsSplit(address adr1,address adr2,uint value);
    
    function Splitter() public{
      owner= msg.sender;
  }
    
 
    
 function splitFunds(address recipient1, address recipient2) public payable returns (bool success){
        
      if (msg.value == 0) throw; // bad input data

      uint amount = msg.value/2;
      uint isAmountOdd = msg.value % 2;
      
      if (isAmountOdd != 0) {    //msg value is odd and there is a remainder return both halves to sender;
          userBalances[msg.sender] += 1;}
      
            userBalances[recipient1]  += amount;
            userBalances[recipient2]  += amount; 
        
         LogFundsSplit(recipient1,recipient2,msg.value);
          return true;
    }
    
   function showContractTotal() view public returns (uint totalAmount) {
         
            totalAmount =this.balance;
    return  totalAmount;
        } 
    
    function killSwitch() public payable
    {
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }
}
    
    
    
    
    