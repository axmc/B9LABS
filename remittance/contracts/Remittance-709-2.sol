pragma solidity ^0.4.19;

// contract Remittance-709-2


// Alice creates the contract and is the owner
// Alice stages the contract by sending pw1 and pw2 to the contract and a value to be transferred;

// the hashes of those passwords are stored in the contract

// a bad actor would associates those passwords only with Alice's address not their hash because he could not be certain 
// of the hashing algorithm used by the contract;





//

// requires that Alice creates the contract and is the owner. Alice has to set up the transfer sending ether to the contract;

// requires that Carol send valid hashes of both Carol and Bob's PasswordCheck which sets an OK to release flag



// 1. Alice sends a request to contract to pay Bob ether

// 2. Contract holds the amount until Carol sends the hash of the two passwords;

// 3. If passwordCheck is OK, funds sent from contract to Carol who converts to BobCurrency; else reverts back to Alice;

contract Remittance {
    
    address public owner;
    address alice_adr;
    address carol_adr;


    
    bool public releaseOK;  // all conditions have been met
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
    // offline or through another contract;
    // Bob does not interact with the contract;

    event LogEmptyTransaction(string _logmsg);
    event LogContractReady(uint _value, string _logmsg,bytes32 pw1Hash, bytes32 pw2Hash);
    event LogSentToCarol (uint amount, string _logmsg);
    event LogContractNotReady(string _logmsg);

    
    
    function Remittance() public {
      owner= msg.sender;
      releaseOK = false;
      contractReady = false;
     
  }


    
 //================PART 1 SET UP THE HASH SECRET ALGORITHM ======================================================
 // this will be called by both Part1 and Part2 of the contract;

     function makeHashSecret(bytes32 secret) internal constant returns(bytes32 hashOfSecret) {

     		require(msg.sender == owner); 
     			hashOfSecret = keccak256(secret);

     		return hashOfSecret;
     }


 //================PART 2 SET UP PASSWORDS ======================================================

 	function setUpPasswords(bytes32 pwForCarol, bytes32 pwForBob) view returns (bytes32 offline_pw1,bytes32 offline_pw2) {

 						 // generate the password hashes 


        		 pw1Hash = makeHashSecret(pwForCarol); 
        		 pw2Hash = makeHashSecret(pwForBob); 

        		 offline_pw1 = pw1Hash;
        		 offline_pw2 = pw2Hash;

        		 return (offline_pw1,offline_pw2);


 	}


 //================PART 3 LOAD FUNDS INTO THE REMITTANCE CONTRACT ======================================================


 function setUpTransfer () public payable returns (bool){
            
            
            uint _value; 
           

                 require(msg.sender == owner);   // the message must come from Alice

                 alice_adr = msg.sender;
         
                 require(msg.value > 0) ;


                contractFunds = contractFunds += msg.value;  // transfer Alice's funds into the contract
                contractReady = true;

                _value = contractFunds;
                
                LogContractReady(_value, "Ready for Carol to execute the contract and send hashes offline",pw1Hash,pw2Hash); 

                return (contractReady);

  }

    //================PART 3 CHECK THE PASSWORDS  ======================================================

function checkPasswords (bytes32 _alicePassword, bytes32 _bobPassword) public returns (bool) {

    	// where the _alicePassword and _bobPassword are the hash that Alice sent out and were delivered offline to Carol
    	// one by email and the other in person.

      require(contractReady);
   

      require(_alicePassword == pw1Hash);
      require(_bobPassword == pw2Hash);

       LogContractReady(contractFunds, "passwords are ok", pw1Hash,pw2Hash);

      releaseOK = true;

      return(releaseOK);

       
}


//================PART 4 TRIGGER THE CONTRACT ======================================================

    

function triggerFundTransfer() public payable {



            require(releaseOK);

            carolsBalance = userAddresses[1] += contractFunds;
            
            

            userAddresses[1] = 0; // to prevent double transfer re-entry;

            contractFunds = 0; //zero out this to prevent double transfer;

            msg.sender.transfer(carolsBalance);



            LogSentToCarol(contractFunds, "Success - funds sent to Carol for conversion to BobCurrency");
              }


        


        

}
 

    
