pragma solidity ^0.4.19;

// contract Remittance-709-4 with Rob's suggestions 28 Feb;

// Alice uses the contract to set up the passwords and locally generates the pwHash 
// passwords sent offline
// Carol (or anyone else with the passwords) can send them to the contract and get the funds
// however the contract zeros out if Carol has been careless or attempt double dipping

// Dave can use the same process to allow Edward to withdraw if he provides two passwords to Edward.


contract Remittance {
    
    address public owner;
    
   
    
    struct RemittanceStruct {
        address remittanceAgent;
        uint amount;
        
        //bytes32 key is the index to the mapping;
    }
    
    mapping(bytes32 => RemittanceStruct) public remittanceStructs;
    
    event LogSentToValidUser (uint amount, string _logmsg);

     function Remittance() public payable {
      owner= msg.sender;
  }
  
  //anyone who sends funds to the contract along with the correct passwords gets put into the struct table
  // with key of pasword hash computed offline by calling the hasher function.
  
  

    function sendRemittance( bytes32 pwHash) public payable returns (bool) {
        
       
        
        remittanceStructs[pwHash].remittanceAgent = msg.sender;
        remittanceStructs[pwHash].amount = msg.value;
        
        return(true);
    }
    
    function hasher(bytes32 pw1, bytes32 pw2) public pure returns(bytes32 hashed){
        return keccak256(pw1,pw2);
    }
    
   function claimFunds(bytes32 pw1, bytes32 pw2) public payable returns (bool success) {
       
       bytes32 key =hasher(pw1,pw2);
       
      require(remittanceStructs[key].amount > 0);
       
           // if submitted passwords hash out to a key not in the table (ie incorrect), the value at that key will be zero
           // so if it is a valid hash it will either have a value or the require screens out legit entries of zero.
           
           // sends to any valid user with passwords - here assumed to be only Carol with passwords in possession
           
           // passwords are transmitted only one time and result in success;
           // Is this vulnerable until block is mined ?
       
       uint payout = remittanceStructs[key].amount;
       
            // put payout amount into memory ie stage the funds for release;
       remittanceStructs[key].amount = 0 ;  // zero out to prevent double dipping. We trust Carol but she can be tempted
       
       msg.sender.transfer(payout);



            LogSentToValidUser(payout, "Success - funds sent to Valid User Carol for conversion to BobCurrency");
        return (true);

    }
}
 

    
