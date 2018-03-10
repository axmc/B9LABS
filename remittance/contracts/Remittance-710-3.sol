pragma solidity ^0.4.19;

// contract Remittance-710-3

// stretch Goals

// SG1 add a deadline
// SG2 Add a limit to how far in the future the deadline can be
// SG3 Add a kill switch


// added making the properRecipient part of the struct so that it becomes a general case instead of just Carol;

// a SuperUser owner creates the contract and sets up the maximum deadline the contract will accept
// then releases info and instructions to Alice on how to use it

// Alice uses the contract to set up the password and identify Carol as the properRecipient;
// Alice also specifies how long she wants the deal to be valid (less than the Max Deadline)
// Alice locally generates the pwHash of the password and Carols address;
// The password is sent to Bob offline, who meets with Carol and hands it over

// Carol can send the password to the contract and get the funds. Anyone else with the password will be blocked.
//  The contract zeros out if Carol has been careless or attempts double dipping





// yet to be done:  Alice to get her money back if not claimed.
//    commission for contract owner
//    commission less than Alice doing it herself


// Dave can use the same process to allow Edward to withdraw if he specifies a password and Edwards address.

//However, Dave or Edward or anyone can specifify a password using hasher and then use SendRemittance to send funds to Carol;
// ie Carol can claim funds from anyone if she has received the password from them;




contract Remittance {
    
    address public owner;
    address properRecipient;

    bool public contractUnderMax;
    bool public contractValid;

    uint contractLength;
    uint dealDeadline;
    uint maxDeadline;
    uint dealLength;
    uint epochSeconds;

    
    struct RemittanceStruct {
        address remittanceAgent;
        address properRecipient;
        uint amount;
        
        //a bytes32 type key is the index to the mapping. it returns a struct of type RemmittanceStruct;
        // Carol is the properRecipient for the funds - no one else should receive them
        // the bytes32 key is the hashed value of the password and Carols address;
    }
    
    mapping(bytes32 => RemittanceStruct) public remittanceStructs;
    
    event LogSentToValidUser (uint amount, string _logmsg);

// End Inits=======================================================================

 // owner sets the Max deadline for the contract    maxDL;
 //
 // owner must set up the contact before release to any users;


 // Alice sets the deadline for her deal which must be < the MaxDL;

 // Claim works if the claim is made where now < dealDL 

 // yet to be done---------------------------------
 // Alice can claim back if dealDL has passed but maxDL is still in the future
 // Alice cannot claim if maxDL has passed - ether is sent to the contract owner;

     function Remittance() public payable {
      owner= msg.sender;
  }


// =================================Stretch Goal 1 add deadline                  /////

    // check to see if contract is active, ie within deadline and below dealineLimit set by owner;


    function isContractActive() public returns (bool contractValid){
          
          contractValid = false;
          require(now < maxDeadline);

          dealLength = now + (dealDeadline*60 +5);

          if (now < dealLength) contractValid = true;
          return (contractValid);

    }




// =================================Stretch Goal 2 set limit to how far the deadline can be ===============

// the owner sets the maximum number of minutes the contract will be valid;
// Alice can set the number of minutes she wants her offer to be valid, after which she can claim ether back;


       function setMaxDL (uint _maxMins) public {

        require (msg.sender == owner);

          uint maxMins = _maxMins;

          epochSeconds = maxMins * 60;

          maxDeadline = now +epochSeconds;

          contractUnderMax = true;

    }

  //=================Stretch Goal 3  ====================================================================

    function killSwitch() public 
    {
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }
    //===================================================================================================
  
  //anyone who sends funds to the contract along with the correct passwords gets put into the struct table 
 
  
// Alice must call the hasher function in order to get the   pwHash value to send the funds;
// Carol has a password but never uses it. In this case her address is used to identify her as the properRecipient;

    function sendRemittance(uint _dealDeadline, bytes32 pwHash,address _properRecipient) public payable returns (bool) {

        dealDeadline = _dealDeadline;

        isContractActive();
        require(contractValid == true); 
                         // make sure now is < owner specified MaxD
                         //and deal can be acceptedL
        
        remittanceStructs[pwHash].remittanceAgent = properRecipient;
        remittanceStructs[pwHash].properRecipient = _properRecipient;
        remittanceStructs[pwHash].amount = msg.value;
        
        return(true);
    }
    

    function hasher(bytes32 pw1, address properRecipient) public pure returns(bytes32 hashed){
    

        return keccak256(pw1,properRecipient);
    }


    
   function claimFunds(bytes32 pw1) public payable returns (bool success) {
        
       isContractActive();
       require(contractValid == true);


       bytes32 key =hasher(pw1,msg.sender);
       
      require(remittanceStructs[key].amount > 0);

       
           // if a submitted password hashes out to a key not in the table (ie incorrect), the value at that key will be zero
           // the password is transmitted only one time and results in either success or failure;
      
       
       uint payout = remittanceStructs[key].amount;
       
            // put payout amount into memory ie stage the funds for release;
       remittanceStructs[key].amount = 0 ;  // zero out to prevent double dipping. We trust Carol but she can be tempted
       
       msg.sender.transfer(payout);



            LogSentToValidUser(payout, "Success - funds sent to Valid User ");
        return (true);

    }
}
 

    
