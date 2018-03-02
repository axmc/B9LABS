pragma solidity ^0.4.19;

// contract Remittance-709-5 with Rob's suggestions March 1 to add address info to the mix.

// Alice uses the contract to set up the password and identify Carol as the properRecipient;
// as the properRecipient and locally generates the pwHash of the password for Bob and Carols address;
// The password is sent to Bob offline, who meets with Carol and hands it over

// Carol  can send them to the contract and get the funds. Anyone else with the password will be blocked.
//  The contract zeros out if Carol has been careless or attempts double dipping

// Dave cannot use the same process to allow Edward to withdraw since the claimFunds can only be claimed by Carol
// from the address she made known to Alice;

//However, Dave or Edward or anyone can specifify a password using hasher and then use SendRemittance to send funds to Carol;
// ie Carol can claim funds from anyone if she has received the password from them;


contract Remittance {
    
    address public owner;
    address public properRecipient;
    
    struct RemittanceStruct {
        address remittanceAgent;
        uint amount;
        
        //a bytes32 type key is the index to the mapping. it returns a struct of type RemmittanceStruct;
        // Carol is the properRecipient for the funds - no one else should receive them
        // the bytes32 key is the hashed value of the password and Carols address;
    }
    
    mapping(bytes32 => RemittanceStruct) public remittanceStructs;
    
    event LogSentToValidUser (uint amount, string _logmsg);


     function Remittance() public payable {
      owner= msg.sender;
      properRecipient = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;


  }
  
  //anyone who sends funds to the contract along with the correct passwords gets put into the struct table 
 
  
// Alice must call the hasher function in order to get the   pwHash value to send the funds;
// Carol has a password but never uses it. In this case her address is used to identify her as the properRecipient;

    function sendRemittance( bytes32 pwHash) public payable returns (bool) {
        
       
        
        remittanceStructs[pwHash].remittanceAgent = properRecipient;
        remittanceStructs[pwHash].amount = msg.value;
        
        return(true);
    }
    

    function hasher(bytes32 pw1, address properRecipient) public pure returns(bytes32 hashed){
        return keccak256(pw1,properRecipient);
    }
    
   function claimFunds(bytes32 pw1) public payable returns (bool success) {

       
       bytes32 key =hasher(pw1,msg.sender);
       
      require(remittanceStructs[key].amount > 0);

       
           // if a submitted password hashes out to a key not in the table (ie incorrect), the value at that key will be zero
           // the password is transmitted only one time and results in either success or failure;
      
       
       uint payout = remittanceStructs[key].amount;
       
            // put payout amount into memory ie stage the funds for release;
       remittanceStructs[key].amount = 0 ;  // zero out to prevent double dipping. We trust Carol but she can be tempted
       
       msg.sender.transfer(payout);



            LogSentToValidUser(payout, "Success - funds sent to Valid User Carol for conversion to BobCurrency");
        return (true);

    }
}
 

    
