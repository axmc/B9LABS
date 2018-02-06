pragma solidity ^0.4.6;
//Minimal contract functions - file version Splitter706-1
// revisions as per  coaching on Slack
// >> indicates questions for Rob 

// objective - to get the splitter contract to run in remix
//  then add in code to address the issue of truncated division of an odd number when split


// I am using the "new remix"  https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js version of remix
//to try and wean off of the version 

// at https://yann300.github.io/#version=soljson-v0.4.19+commit.c4cbbb05.js used in the class examples
// but cannot get this code to compile on the older remix.

// >> Rob, is there any reason this should occur ?  Old remix and new remix are both set to Solidity version 
// 0.4.19+commit.c4cbbb05.Emscripten.clang






contract Splitter{
    
    address public owner;
  
    

    
    mapping (address => uint) public userBalances;
    
    event LogFundsSplit(string _msg);
    
    function Splitter() public{
      owner= msg.sender;

      // looks like the owner is not actually used, but confirms in remix
  }
    
 //>> Rob - It looks like type can be explicitly declared either within a function as here with address recipient1  and is good inside that function only 
 //   or globally above. It seems that parser complains 
 //   some times. Is there good practice recommendation ?
    
 function splitFunds(address recipient1, address recipient2) public payable returns (bool success){
        
      uint amount = msg.value/2;
            userBalances[recipient1]  += amount;
            userBalances[recipient2]  += amount; 
              return true;

//this works when I send amount of either wei or ether and check using the function userBalances.  So far so good

// >> Rob - is this event positioned properly? I cannot see it fire in the grey remix window below the code .              
           
         LogFundsSplit("funds have been split");
    }
    
    
    function showContractTotal() public returns (uint totalAmount) {
         
            totalAmount =this.balance;
    return  totalAmount;
        }
// >> Rob- this has me stumped. totalAmount = this.balance will at least compile, but delivers null. If I define 

//       totalAmount  = userBalances[recipient1] + userBalances[recipient2]; it will not compile
//    
// even though it looks to me that it should work


// nor will  totalAmount  = userBalances[address recipient1] + userBalances[address recipient2];  compile in fact 
// remix parser complains 

//
//            browser/Splitter706-1.sol:33:47: ParserError: Expected token RBrack got 'Identifier'
//            totalAmount =userBalances[address recipient1] + userBalances[address recipient2];
//                                              ^

// yet you probably will not know the addresses to pass in if you want to know the balance in the contract
// for an arbitrary number of users

        
    function userBalances(address index) public constant returns (uint balanceAtAddress)  {
            return userBalances[index];
    
        }
// this function works fine, as I would think pointing to the mapping using the address as the index and the balance 
// as the mapped value is how it should work.

// but trying to simplify further, I tried this which offers a confusing result. I thought that the pattern 

// <address>.balance would return the uint256 balance of that account. 

        function simpleUserBalance(address directindex)public constant returns (uint balanceAtSimpleAddress){
            balanceAtSimpleAddress = directindex.balance;
            return balanceAtSimpleAddress;
        }

}

// I suspect that I am getting charged for gas because when I run a fresh copy of the contract and use the simpleUserBalance
// the 100 ether becomes slightly less ,say balanceAtSimpleAddress 99999999999997000000.

// but if I query it at userBalances even before the splitFUnds function has been run it returns 0. As I would expect.
// OK - now if I send 44 wei to that account, the userBalances shows a balance of 22, but if I then query simpleUserBalance again
// it goes back up to 100 ether as the balance.


// I I then send 66 ether to the split that account will show balanceAtAddress 33000000000000000022 - as I expect 
// but if I check it again with simpleUserBalance it is still at 100 ether.

// >> Rob, am I seeing some ether inside the contract and some outside of the contract in the users wallet ? If so, does it have 
// to be explicitly transferred out by the contact in order to credit that user ?
// I confused as to what I am seeing here.


    
    
    
    
    
    
    

