pragma solidity 0.4.19 ;
// contract Remittance-706-3


contract Remittance{
    
    address public owner;
    bool releaseOK;
    uint amount;
    

    
    mapping (address => uint) public userAddresses;
    
    event LogFundsSplit(address adr1,address adr2, uint value);
    event LogInsufficientFundsFromAlice(uint amount, uint balance);
    event LogPasswordMismatch(msg.sender,msg.value);
    event LogEmptyTransaction(string _msg);
    
    function Remittance() public{
      owner= msg.sender;
      releaseOK = false;
  }
    
 
    
 function sendFunds(address recipient1, address recipient2) public payable returns (bool success){
        
      if (msg.value == 0) { // bad input data 
          LogEmptyTransaction("No valid payload");

        throw;

        }  

          AlicesPasswordChecker(msg.sender,msg.value) returns(releaseOK);


      if (releaseOK != true) {
        LogPasswordMismatch(msg.sender,msg.value);
        throw;

          CarolsExchangeService( msg.value, address _destination) returns (bool success);


      }
 
//=====================================================================================

    function killSwitch() public payable
    {
      if (msg.sender == owner) {s
        selfdestruct(owner);}
    }


//=====================================================================================

   
    function CarolsExchangeService (uint _amount, address _destination) public payable returns (bool success) {
                 // Carol charges a 10% commission
                 // first check to see if Carol's account has the money
                 amount = _amount;
                 uint aliceBalance = userAddresses[0].balances;
                 if (aliceBalance < amount) {

                  LogInsufficientFundsFromAlice (amount,aliceBalance);

                  } throw;

          uint jiffies =  amount *.90;  // Bob's local currency is the Jiffy  1 JIF = 1 eth less Carol's commission

          userAddresses[1].transfer (uint jiffies);



    }

    function AlicesPasswordChecker ( address _carolsPassword, address _bobsPassword) private returns(bool releaseOK){
        carolsPassword = msg.sender;
        bobsPassword = msg.value;

      if (carolsPassword == userAddresses[2] && (bobsPassword == userAddresses[1]) {

        releaseOK = true;
      }
    }
}
    
    
    
    
    