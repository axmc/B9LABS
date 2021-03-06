pragma solidity ^0.4.19;

// contract Remittance-711-3
// Following discussio with Rob March 13

// stretch Goals

// SG1 add a deadline for a deal, after which Alice can claim back the unchallenged ether.

// Alice uses the clawbackFunds() function to reclaim funds after the deal time expires

// We assume the contract is active forever but deals come and go




// Alice uses the contract to set up the password, specifify a time limit for the deal, and identify Carol as the properRecipient;

//Alice must call hasher() and set password and properRecipient
// then she must send remittance specifying deal duration, password, recipient and message value;

// Alice locally generates the pwHash of the password and Carols address;
// The password is sent to Bob offline, who meets with Carol and hands it over

// Carol can send the password to the contract and get the funds. Anyone else with the password will be blocked.
// If Carol does not claim the funds within the deadline, Alice can withdraw the funds
//  The contract zeros out if Carol has been careless or attempts double dipping


contract Remittance {
    
    address public owner;
    address properRecipient;
    address _remittanceAgent;

  
    bool public dealIsValid;
    bool public contractIsValid;  // for future use

    uint public dealDeadline;
    uint dealLength;
    uint amount;
  
    string _logmsg;
    

    
    struct RemittanceStruct {
        address remittanceAgent;
        address properRecipient;
        uint amount;
        
        //a bytes32 type key is the index to the mapping. it returns a struct of type RemmittanceStruct;
        // Carol is the properRecipient for the funds - no one else should receive them while the contract is valid
        // the bytes32 key is the hashed value of the password and Carols address;
    }
    
    mapping(bytes32 => RemittanceStruct) public remittanceStructs;
    
    event LogSentToValidUser (uint amount, string _logmsg);
    event LogDealEntered (uint amount, uint dealLength, string _logmsg);

// End Inits=======================================================================
     function Remittance()
     public
     payable
     {
      owner= msg.sender;
      _remittanceAgent = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
      contractIsValid =  true;  // remove for future use
      // Carol is set as remittanceAgent. Recipient can be someone else but
      // for this contract funds always go to Carol for conversion.
  }


    function isDealActive() 
	    public
	    returns (bool dealIsValid) 
	    {
          if(now < dealDeadline) dealIsValid = true;

          return (dealIsValid);

    }
 //=================Stretch Goal 3  ====================================================================

    function killSwitch() 
    	public 
    	{
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }
    //===================================================================================================
  
// Alice must call the hasher function in order to get the   pwHash value to send the funds;
// Carol has a password but never uses it. In this case her address is used to identify her as the properRecipient;

    function sendRemittance(uint dealLength, bytes32 pwHash, address _properRecipient)
	    public
	    payable
	    returns (bool)
	    {

       		amount = msg.value;
        		_logmsg = " mins for the deal to be closed ";

        	dealDeadline = now + (dealLength*60); // calculates the deadline and sets the input time in minutes into the state variable read by isDealActive()

        isDealActive();
        require(contractIsValid == true); 
                            
	        remittanceStructs[pwHash].remittanceAgent = msg.sender;
	        remittanceStructs[pwHash].properRecipient = _properRecipient;
	        remittanceStructs[pwHash].amount = msg.value;

	     LogDealEntered (amount, dealLength, _logmsg );
	        
        return(true);
    }
    

    function hasher(bytes32 pw1, address properRecipient)
    		 public
    		 pure
    		 returns(bytes32 hashed)
    		 {
    

        return keccak256(pw1,properRecipient);
    }


    
   function claimFunds(bytes32 pw1)
   		public
   		payable 
   		returns (bool success)
   		{
	       isDealActive();

	       if(contractIsValid == true){
	       		bytes32 key =hasher(pw1,msg.sender);
	 
	       		require(remittanceStructs[key].amount > 0);
	       
		       uint payout = remittanceStructs[key].amount;
		       
		            // put payout amount into memory ie stage the funds for release;
		       remittanceStructs[key].amount = 0 ;  // zero out to prevent double dipping. We trust Carol but she can be tempted
		       
		       msg.sender.transfer(payout);



	            LogSentToValidUser(payout, "Success - funds sent to Carol");

	            }
	            
            return(true);
            
   }
   
            


      function clawbackFunds(bytes32 pw1, address oldRecipient)
	      public 
	      payable 
	      returns (bool success) 
	      {
        
	         require (msg.sender == owner);

	            isDealActive();

		    if(contractIsValid == false){



       		bytes32 key =hasher(pw1,oldRecipient);
           
	       uint payout = remittanceStructs[key].amount;
	       
	            // put payout amount into memory ie stage the funds for release;

	       
	      owner.transfer(payout);



            LogSentToValidUser(payout, "Success - funds returned to Owner ");

             }
 
        return (true);

    }
}
 

