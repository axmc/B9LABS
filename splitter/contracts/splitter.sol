pragma solidity ^0.4.6;
//Minimal contract functions
contract Splitter705dot3A{
    
    address public owner;
    address newMember;
   
    address whoIsSending;
  
    bool status;
    
    uint numUsers;
    uint amount;
    
    mapping (address => uint) userBalances;
    
    address[] userIndex;
    
    event reportNumUsersExceeded(string _msg);
    
    function Splitter705dot3A() public{
      owner= msg.sender;
  }
    
    function setUpMembers(address _address)  public payable {
        // only owner can add members
        // Users are A.B.C in order of arrival . Only three members/addresses are accepted.
        
     if(msg.sender != owner) throw;
        
        newMember = _address;
        userIndex.push (newMember) -1;
        
        numUsers=userIndex.length;
        
        if (numUsers > 3) {
            reportNumUsersExceeded('Too Many Users');
       throw;}
    } 
    
 function goSendFunds(address destination) public payable returns (bool success){
        // amount is the payload of the message
        whoIsSending = msg.sender;
        
        
         if (whoIsSending == owner) // send it on to destination
             
             {userBalances[destination] += msg.value;
                 status = true;
                 return status;
             }
        
        if (whoIsSending == userIndex[0])  // don't care what destination is if Alice sends but it will return false
           {amount = msg.value/2;
            userBalances[userIndex[1]]  += amount;
            userBalances[userIndex[2]]  += amount; 
               status = false;
               return status;
           }
            
         if (whoIsSending == userIndex[1] || whoIsSending == userIndex[2]) // send it on to destination
             
             {userBalances[destination] += msg.value;
                 status = true;
                 return status;
             } 
        
       
        
        }
        
        function showAlice() public returns (uint)   {
            amount = userBalances[userIndex[0]];
            return amount;
            
        }
        function showBob() public returns (uint) {
            amount = userBalances[userIndex[1]];
            return amount;
            
        }
        function showCarol() public returns (uint) {
            amount = userBalances[userIndex[2]];
            return amount;
            
        }
        
        function showContractTotal() public returns (uint){
            
            amount = userBalances[userIndex[0]] + userBalances[userIndex[1]] + userBalances[userIndex[2]];
            return amount;
        }
    }
        
        
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    

