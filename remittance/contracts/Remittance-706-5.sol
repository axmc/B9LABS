pragma solidity 0.4.19;

// contract Remittance-708-1

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

    bytes32 alicePasswordHash;
    bytes32 bobPasswordHash;

    
    mapping (address => uint) public userAddresses;

    // Owner is address 0 who is Alice since it is her contract;
    // Carol is address 1 since she is the only other participant in the contract. Bob and Carol interact either
    //   offline or through another contract;


   
    event LogPasswordMismatch(string _logmsg);
    event LogEmptyTransaction(string _logmsg);
    event LogContractReady(uint _value, string _logmsg);
    event LogSentToCarol (uint amount, string _logmsg);
    event LogContractNotReady(string _logmsg);
    
    function Remittance() payable public {
      owner= msg.sender;
      releaseOK = false;
      contractReady = false;
      alicePasswordHash = 0x02b20c2969bb3a3572c45413e5cbccdad22447c2e78c807252a880eaeb9df7b6;
      bobPasswordHash =   0x4f3f3c57c67c304d5908ee677e1e5cba35a5fac85cd936db7784abdb8aadf02d;
  }

//=================FOR FUTURE USE ====================================================================

    function killSwitch() public 
    {
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }

 //================PART 1 SET UP THE REMITTANCE CONTRACT ======================================================

 function setUpTransfer ()  public payable {
            
            
            uint _value;
            string memory _logmsg;

    // must come from Alice;
 
                 if(msg.sender !=owner) throw;   // the message must come from Alice
                 
            // Alice must send funds with her message;

                  if (msg.value == 0) { // bad input data 
                LogEmptyTransaction("No payload");
                  throw; }   


        // thus all the above are ok and we can proceed;

                contractFunds = contractFunds += msg.value;
                contractReady = true;
                _value = contractFunds;
               _logmsg = "Ready for Carol to execute the contract";
               
                LogContractReady(contractFunds, _logmsg);

     

  }

    //================PART 2 TRIGGER THE CONTRACT ======================================================


    function triggerContractAction (bytes32 _alicePassword, bytes32 _bobPassword) public payable {
      

      // make sure transfer is set up by Alice and is ready to execute if passwords are correct;

      if (!contractReady) { 

              LogContractNotReady(" contract is not ready to execute");
               throw;
                }

      if( (_alicePassword == alicePasswordHash) && (_bobPassword == bobPasswordHash)) {
          
           
            carolsBalance = userAddresses[1] += contractFunds;
            
             LogContractReady(contractFunds, "passwords are ok");

            userAddresses[1] = 0; // to prevent double transfer re-entry;
            contractFunds = 0; //zero out this to prevent double transfer;
            msg.sender.transfer(carolsBalance);



              LogSentToCarol(contractFunds, "Success - funds sent to Carol for conversion to BobCurrency");
              throw; }


        


         LogPasswordMismatch("Password Mismatch- nothing released");


      }
 

}

// =================================END==================================================================
    
    
    
    
    