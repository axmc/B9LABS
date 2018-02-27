
pragma solidity 0.4.19;

// contract Remittance-709-1


// Alice creates the contract and then stages it by sending pw1 and pw2 to the contract and a value to be transferred;

// the hashes of those passwords are stored in the contract and are not returned

// a bad actor would associates those passwords only with Alice's address not their hash because he could not be certain 
// of the hashing algorithm used by the contract;





//

// requires that Alice creates the contract and is the owner. Alice has to set up the transfer sending ether to the contract;

// requires that Carol send valid hashes of both Carol and Bob's PasswordCheck which sets an OK to release flag



// 1. Alice sends a request to contract to pay Bob ether

// 2. Contract holds the amount until Carol sends the hash of the two passwords;

// 3. If passwordCheck is OK, funds sent from contract to Carol who converts to BobCurrency; else reverts back to Alice;

contract Remittance{
    
    address public owner;
    
    bool releaseOK;  // all conditions have been met
    bool public contractReady; // funds are in contract but password conditions unknown

    uint aliceBalance;
    uint carolsBalance;
    uint amountToBeSent;
    uint public contractFunds;

    bytes32 public pw2Hash;
    bytes32 public pw1Hash;

    
    mapping (address => uint) public userAddresses;

    // Owner is address 0 who is Alice since it is her contract;
    // Carol is address 1 since she is the only other participant in the contract. Bob and Carol interact either
    //   offline or through another contract;


   
    event LogPasswordMismatch(string _logmsg);
    event LogEmptyTransaction(string _logmsg);
    event LogContractReady(uint _value, string _logmsg, bytes32 _pw1Hash, bytes32 _pw2Hash);
    event LogSentToCarol (uint amount, string _logmsg);
    event LogContractNotReady(string _logmsg);
    
    function Remittance() payable public {
      owner= msg.sender;
      releaseOK = false;
      contractReady = false;
     
  }

//=================FOR FUTURE USE ====================================================================

    function killSwitch() public 
    {
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }

    
         //================PART 1 SET UP THE HASH SECRET ALGORITHM ======================================================

     function hashSecret(bytes32 secret) internal constant returns(bytes32 hashSecret) {

     		if(msg.sender !=owner) throw; 

     		return keccak256(secret);
     }


 //================PART 2 SET UP THE REMITTANCE CONTRACT ======================================================

 function setUpTransfer ( bytes32 password1, bytes32 password2)  public payable returns (bytes32 pw1Hash, bytes32 pw2Hash) {
            
            
            uint _value;
            string memory _logmsg;

    // must come from Alice;
 
                 if(msg.sender !=owner) throw;   // the message must come from Alice
                 
            // Alice must send funds with her message;

                  if (msg.value == 0) { // bad input data 
                LogEmptyTransaction("No payload");
                  throw; }   


        // thus all the above are ok and we can proceed to the generation of password hashes;

        		 pw1Hash = hashSecret(password1);
        		 pw2Hash = hashSecret(password2); 

                contractFunds = contractFunds += msg.value;
                contractReady = true;
                _value = contractFunds;
               _logmsg = "Ready for Carol to execute the contract";
               
                LogContractReady(contractFunds, _logmsg, pw1Hash, pw2Hash);

                return (pw1Hash, pw2Hash);



     

  }

    //================PART 3 TRIGGER THE CONTRACT ======================================================


    function triggerContractAction (bytes32 _alicePassword, bytes32 _bobPassword) public payable {

    	// where the _alicePassword and _bobPassword are really pw1Hash and pw2Hash;
      

      // make sure transfer is set up by Alice and is ready to execute if passwords are correct;

      if (!contractReady) { 

              LogContractNotReady(" contract is not ready to execute");
               throw;
                }

      if( (_alicePassword == pw1Hash) && (_bobPassword == pw2Hash)) {
          
           
            carolsBalance = userAddresses[1] += contractFunds;
            
             LogContractReady(contractFunds, "passwords are ok", pw1Hash,pw2Hash);

            userAddresses[1] = 0; // to prevent double transfer re-entry;
            contractFunds = 0; //zero out this to prevent double transfer;
            msg.sender.transfer(carolsBalance);



              LogSentToCarol(contractFunds, "Success - funds sent to Carol for conversion to BobCurrency");
              throw; }


        


         LogPasswordMismatch("Password Mismatch- nothing released");


      }
 

}

// =================================END==================================================================
    
    
    
    
