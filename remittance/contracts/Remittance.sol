pragma solidity 0.4.19 ;
// contract Remittance-706-4

// requires all three parties to register with the contract

// their address when they register becomes their password;
// Alice sends her wallet address to Carol as her password
// Bob sends his wallet address to Carol as his password

// carol must send a message to the congtract with both correct wallet addresses;

// is there potential for unauthoirzed pull by malicious carol? 



contract Remittance{
    
    address public owner;
    bool releaseOK;
    uint amount;
    uint jiffies;
    

    
    mapping (address => uint) public userAddresses;
    
   
    event LogInsufficientFundsFromAlice(uint amount, uint balance);
    event LogPasswordMismatch(msg.sender,msg.value);
    event LogEmptyTransaction(string _msg);
    event LogSentToBob (uint amount);
    
    function Remittance() public{
      owner= msg.sender;
      releaseOK = false;
  }
    
 
    
 
//=====================================================================================

    function killSwitch() public payable
    {
      if (msg.sender == owner) {
        selfdestruct(owner);}
    }


//=====================================================================================

   
    function CarolsExchangeService (uint _amount, address _destination) public payable returns (bool success) {
                 // Carol charges a 10% commission
                 
                 
                 if(msg.sender != userAddresses[0]) throw;   // the message must come from Alice
                 // but Alice can send to anyone
                 
           amount = _amount;
           uint aliceBalance = userAddresses[0].balances;

                     if (aliceBalance < amount) {

                      LogInsufficientFundsFromAlice (amount,aliceBalance);

                      } throw;

          uint inputToConversion = userAddresses[0]. transfer (amount);

          jiffies =  inputToConversion *.90;  // Bob's local currency is the Jiffy  1 JIF = 1 eth less Carol's commission

          userAddresses[1].transfer(jiffies);
          LogSentToBob (jiffies);
          return true;

    }

    function AlicesPasswordChecker (address _CarolsPassword, address _bobsPassword) private returns(bool releaseOK){
        if (_carolsPassword != msg.sender) throw;   // carol must be the message sender to Alice;
        
        bobsPassword = msg.value;

      if( (carolsPassword == userAddresses[2]) && (bobsPassword == userAddresses[1])) {

        releaseOK = true;
        return releaseOK;
      }
      
    }
    
    function sendFundsToBob(address _bobsPassword) public payable returns (bool success){
        
      if (msg.value == 0) { // bad input data 
          LogEmptyTransaction("No valid payload");
        throw;

        }  

          AlicesPasswordChecker(msg.value); 


      if (releaseOK != true) {
        LogPasswordMismatch(msg.sender,msg.value);
        throw;
        address _destination = userAddresses[2];
        _amount = msg.value;

          CarolsExchangeService(uint _amount, address _destination) returns (bool success);


      }
 }
 
}
    
    
    
    
    